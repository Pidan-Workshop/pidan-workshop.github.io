# encoding: utf-8
# 多语言页面生成器插件
# 从 _templates/ 目录读取模板，结合 _locale/ 翻译数据，直接生成到 _site

require 'yaml'
require 'fileutils'

module Jekyll
  # 多语言页面生成器
  class LocaleGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      @site = site
      
      # 检查 languages 数据
      unless site.data['languages']
        Jekyll.logger.error "LocaleGenerator:", "No 'languages' data found in _data/languages.yml"
        return
      end
      
      @languages = site.data['languages'].keys
      
      Jekyll.logger.info "LocaleGenerator:", "Starting multi-language page generation..."
      Jekyll.logger.info "LocaleGenerator:", "Languages: #{@languages.join(', ')}"
      
      # 读取所有 locale 文件
      @locale_data = load_locale_data
      Jekyll.logger.info "LocaleGenerator:", "Loaded #{@locale_data.keys.size} locale files"
      
      # 处理所有模板文件
      template_files = find_template_files
      Jekyll.logger.info "LocaleGenerator:", "Found #{template_files.size} template files"
      
      @generated_count = 0
      template_files.each do |template_path|
        generate_pages_from_template(template_path)
      end
      
      Jekyll.logger.info "LocaleGenerator:", "Generated #{@generated_count} pages"
    end

    private

    # 加载所有 locale 数据
    def load_locale_data
      locale_data = {}
      locale_dir = File.join(@site.source, '_locale')
      
      return locale_data unless Dir.exist?(locale_dir)
      
      Dir.glob(File.join(locale_dir, '**', '*.yml')).each do |file|
        relative_path = file.sub("#{locale_dir}/", '')
        ref = compute_ref_from_path(relative_path)
        
        begin
          data = YAML.load_file(file)
          locale_data[ref] = data
          Jekyll.logger.debug "LocaleGenerator:", "Loaded locale: #{ref}"
        rescue => e
          Jekyll.logger.error "LocaleGenerator:", "Error loading #{file}: #{e.message}"
        end
      end
      
      locale_data
    end

    # 从文件路径计算 ref
    def compute_ref_from_path(path)
      # 移除 .yml 后缀
      ref = path.sub(/\.yml$/, '')
      
      # 如果是 index.yml，转换为父目录名或 home
      if ref == 'index'
        'home'
      elsif ref.end_with?('/index')
        ref.sub(/\/index$/, '')
      else
        ref
      end
    end

    # 查找所有模板文件
    def find_template_files
      templates_dir = File.join(@site.source, '_templates')
      return [] unless Dir.exist?(templates_dir)
      
      Dir.glob(File.join(templates_dir, '**', '*.{html,md}'))
    end

    # 从模板生成多语言页面
    def generate_pages_from_template(template_path)
      # 读取模板内容
      content = File.read(template_path)
      
      # 解析 front matter
      if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        front_matter = YAML.safe_load($1)
        body = $'
      else
        Jekyll.logger.warn "LocaleGenerator:", "No front matter in #{template_path}"
        return
      end
      
      # 验证必需字段
      ref = front_matter['ref']
      unless ref
        Jekyll.logger.error "LocaleGenerator:", "Missing 'ref' in #{template_path}"
        return
      end
      
      # 获取 locale 数据
      locale_data = @locale_data[ref]
      unless locale_data
        Jekyll.logger.error "LocaleGenerator:", "No locale data for ref '#{ref}'"
        return
      end
      
      # 计算输出路径（相对于 _templates/ 目录）
      templates_dir = File.join(@site.source, '_templates')
      relative_path = template_path.sub("#{templates_dir}/", '')
      
      # 为每种语言生成页面
      @languages.each do |lang|
        generate_page(relative_path, lang, front_matter, body, locale_data)
      end
    end

    # 生成单个语言的页面
    def generate_page(relative_path, lang, front_matter, body, locale_data)
      # 获取标题
      title_data = locale_data['title']
      title = title_data ? title_data[lang] : front_matter['title']
      
      unless title
        Jekyll.logger.warn "LocaleGenerator:", "No title for #{relative_path} (#{lang})"
        title = "Untitled"
      end
      
      # 构建新的 front matter
      new_front_matter = front_matter.dup
      new_front_matter['lang'] = lang
      new_front_matter['title'] = title
      # 将 locale 数据存储在 page_locale 而不是 locale，避免与 seo-tag 冲突
      new_front_matter['page_locale'] = locale_data
      
      # 计算 permalink
      # 例如：about/index.html -> /en/about/ 或 /zh/about/
      dir_path = File.dirname(relative_path)
      if dir_path == '.'
        permalink = "/#{lang}/"
      else
        permalink = "/#{lang}/#{dir_path}/"
      end
      new_front_matter['permalink'] = permalink
      
      # 创建 LocalePage 对象
      page = LocalePage.new(@site, @site.source, lang, relative_path, new_front_matter, body)
      @site.pages << page
      
      @generated_count ||= 0
      @generated_count += 1
      
      Jekyll.logger.debug "LocaleGenerator:", "Generated #{lang}/#{relative_path} -> #{permalink}"
    end
  end

  # 自定义页面类
  class LocalePage < Page
    def initialize(site, base, lang, relative_path, front_matter, body)
      @site = site
      @base = base
      @dir = File.join(lang, File.dirname(relative_path))
      @name = File.basename(relative_path)
      
      self.process(@name)
      
      # 设置内容
      self.content = body
      self.data = front_matter
      
      # 确保 layout 存在
      self.data['layout'] ||= 'default'
    end
    
    # 读取方法（必需）
    def read_yaml(*)
      # 不需要读取，因为我们已经在初始化时设置了内容
    end
  end
end
