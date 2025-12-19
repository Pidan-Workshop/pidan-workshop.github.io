#!/usr/bin/env ruby
# encoding: utf-8

# 从模板生成多语言页面
# 读取 _templates/ 目录中的模板文件
# 为每种语言生成对应的文件到 en/ 和 zh/ 目录

require 'yaml'
require 'fileutils'

# 颜色输出
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def log_info(message)
  puts colorize("[INFO] #{message}", 34)  # 蓝色
end

def log_success(message)
  puts colorize("[SUCCESS] #{message}", 32)  # 绿色
end

def log_error(message)
  puts colorize("[ERROR] #{message}", 31)  # 红色
end

def log_warning(message)
  puts colorize("[WARNING] #{message}", 33)  # 黄色
end

# 解析 YAML front matter
def parse_front_matter(content)
  if content =~ /\A---\s*\n(.*?\n?)^---\s*$\n?/m
    front_matter = YAML.safe_load($1)
    body = content[$~.end(0)..-1]
    return front_matter, body
  else
    return {}, content
  end
end

# 根据 locale 文件路径计算 ref
def compute_ref_from_locale_path(locale_file_path)
  # 移除 _locale/ 前缀和 .yml 后缀
  relative_path = locale_file_path.sub(/^_locale\//, '').sub(/\.yml$/, '')
  
  # 如果是 index.yml，转换为 home；如果是子目录下的 index.yml，去掉 /index
  if relative_path == 'index'
    'home'
  elsif relative_path.end_with?('/index')
    relative_path.sub(/\/index$/, '')
  else
    relative_path
  end
end

# 验证模板
def validate_template(front_matter, template_path, locale_files)
  ref = front_matter['ref']
  
  unless ref
    raise "Template '#{template_path}' is missing 'ref' field in front matter"
  end
  
  unless locale_files.include?(ref)
    raise "No locale file found for ref: '#{ref}'. Create _locale/#{ref}.yml or _locale/#{ref}/index.yml"
  end
  
  unless front_matter['layout']
    log_warning "Template '#{template_path}' is missing 'layout' field"
  end
end

# 生成单个页面
def generate_page(template_path, output_path, lang, title, front_matter, body)
  # 创建输出目录
  output_dir = File.dirname(output_path)
  FileUtils.mkdir_p(output_dir)
  
  # 构建新的 front matter
  new_front_matter = front_matter.dup
  new_front_matter['lang'] = lang
  new_front_matter['title'] = title
  
  # 生成新文件内容（不使用 YAML.dump，手动构建以保持格式）
  content = "---\n"
  new_front_matter.each do |key, value|
    content += "#{key}: #{value}\n"
  end
  content += "---\n"
  content += body
  
  # 写入文件
  File.write(output_path, content)
  log_success "Generated: #{output_path}"
end

# 主函数
def main
  log_info "Starting page generation from templates..."
  
  # 检查必需的目录和文件
  unless Dir.exist?('_templates')
    log_error "_templates/ directory not found"
    exit 1
  end
  
  unless Dir.exist?('_locale')
    log_error "_locale/ directory not found"
    exit 1
  end
  
  unless File.exist?('_data/languages.yml')
    log_error "_data/languages.yml not found"
    exit 1
  end
  
  # 加载配置文件
  log_info "Loading configuration files..."
  languages = YAML.load_file('_data/languages.yml')
  
  log_info "Found #{languages.keys.length} languages: #{languages.keys.join(', ')}"
  
  # 加载所有 locale 文件（从 _locale/ 及其子目录）
  log_info "Loading locale files..."
  locale_files = {}
  Dir.glob('_locale/**/*.yml').each do |locale_file|
    ref = compute_ref_from_locale_path(locale_file)
    locale_files[ref] = YAML.load_file(locale_file)
    log_info "Loaded locale: #{ref} (from #{locale_file})"
  end
  
  # 查找所有模板文件
  template_files = Dir.glob('_templates/**/*.html') + Dir.glob('_templates/**/*.md')
  log_info "Found #{template_files.length} template files"
  
  if template_files.empty?
    log_warning "No template files found in _templates/"
    return
  end
  
  # 处理每个模板文件
  generated_count = 0
  error_count = 0
  
  template_files.each do |template_path|
    begin
      log_info "Processing: #{template_path}"
      
      # 读取模板内容
      content = File.read(template_path, encoding: 'utf-8')
      front_matter, body = parse_front_matter(content)
      
      # 验证模板
      validate_template(front_matter, template_path, locale_files.keys)
      
      ref = front_matter['ref']
      locale_data = locale_files[ref]
      titles = locale_data['title']
      
      # 为每种语言生成文件
      languages.keys.each do |lang|
        title = titles[lang]
        
        unless title
          log_warning "No title found for ref '#{ref}' in language '#{lang}'"
          next
        end
        
        # 计算输出路径
        # _templates/index.html -> en/index.html, zh/index.html
        # _templates/about/index.html -> en/about/index.html, zh/about/index.html
        relative_path = template_path.sub('_templates/', '')
        output_path = File.join(lang, relative_path)
        
        # 生成页面
        generate_page(template_path, output_path, lang, title, front_matter, body)
        generated_count += 1
      end
      
    rescue => e
      log_error "Failed to process #{template_path}: #{e.message}"
      log_error e.backtrace.join("\n") if ENV['DEBUG']
      error_count += 1
    end
  end
  
  # 输出总结
  puts "\n" + "=" * 60
  log_info "Generation complete!"
  log_success "Generated: #{generated_count} files"
  log_error "Errors: #{error_count}" if error_count > 0
  puts "=" * 60
  
  exit error_count > 0 ? 1 : 0
end

# 运行主函数
if __FILE__ == $0
  main
end
