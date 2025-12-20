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
      
      Jekyll.logger.info "LocaleGenerator:", "Starting multi-language page generation (#{@languages.join(', ')})"
      
      # 统一加载所有 locale 和翻译数据
      @locale_data = load_all_locale_data
      @common_translations = site.data['translations'] || {}
      
      # 预构建翻译缓存
      @translation_cache = {}
      
      # 处理所有模板文件
      template_files = find_template_files
      Jekyll.logger.info "LocaleGenerator:", "Processing #{template_files.size} templates"
      
      @generated_count = 0
      template_files.each { |path| generate_pages_from_template(path) }
      
      # 为每个游戏生成详情页
      generate_game_detail_pages if @site.data['games']&.any?
      
      Jekyll.logger.info "LocaleGenerator:", "Generated #{@generated_count} pages"
    end

    private

    # 统一加载所有 locale 数据（含 common 和 includes）
    def load_all_locale_data
      locale_data = {}
      locale_dir = File.join(@site.source, '_locale')
      
      return locale_data unless Dir.exist?(locale_dir)
      
      # 跳过 includes 目录（单独处理）
      Dir.glob(File.join(locale_dir, '**', '*.yml')).each do |file|
        next if file.include?('includes/')
        
        relative_path = file.sub("#{locale_dir}/", '')
        ref = compute_ref_from_path(relative_path)
        
        begin
          data = YAML.load_file(file)
          locale_data[ref] = data
        rescue => e
          Jekyll.logger.error "LocaleGenerator:", "Error loading #{file}: #{e.message}"
        end
      end
      
      # 加载所有 includes/*.yml 翻译到全局 translations
      translations = {}
      includes_dir = File.join(locale_dir, 'includes')
      if Dir.exist?(includes_dir)
        Dir.glob(File.join(includes_dir, '*.yml')).each do |file|
          begin
            data = YAML.load_file(file)
            translations.merge!(data)
          rescue => e
            Jekyll.logger.error "LocaleGenerator:", "Error loading include #{file}: #{e.message}"
          end
        end
      end
      
      # 加载 common.yml 翻译
      common_file = File.join(locale_dir, 'common.yml')
      if File.exist?(common_file)
        begin
          translations.merge!(YAML.load_file(common_file))
        rescue => e
          Jekyll.logger.error "LocaleGenerator:", "Error loading common.yml: #{e.message}"
        end
      end
      
      # 保存到 site.data 供 hooks 使用（避免重复加载）
      @site.data['translations'] = translations
      
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
      title = locale_data['title']&.dig(lang) || front_matter['title'] || "Untitled"
      
      # 构建新的 front matter
      new_front_matter = front_matter.dup
      new_front_matter['lang'] = lang
      new_front_matter['title'] = title
      new_front_matter['permalink'] = compute_permalink(relative_path, lang)
      new_front_matter['translations'] = build_translations_cached(locale_data, lang)
      
      # 创建 LocalePage 对象
      @site.pages << LocalePage.new(@site, @site.source, lang, relative_path, new_front_matter, body)
      @generated_count += 1
    end
    
    # 构建合并的翻译数据（缓存以提高性能）
    def build_translations_cached(locale_data, lang)
      cache_key = "#{locale_data.object_id}_#{lang}"
      return @translation_cache[cache_key] if @translation_cache[cache_key]
      
      translations = {}
      
      # 1. 加载页面特定翻译
      locale_data.each do |key, value|
        translations[key] = value[lang] if key != 'title' && value.is_a?(Hash) && value[lang]
      end
      
      # 2. 加载全局翻译（common + includes）
      @common_translations.each do |key, value|
        if value.is_a?(Hash) && value[lang]
          translations[key] = value[lang]
        end
      end
      
      @translation_cache[cache_key] = translations
      translations
    end
    
    # 计算 permalink
    def compute_permalink(relative_path, lang)
      dir_path = File.dirname(relative_path)
      if dir_path == '.'
        "/#{lang}/"
      else
        "/#{lang}/#{dir_path}/"
      end
    end
    
    # 为每个游戏生成详情页
    def generate_game_detail_pages
      locale_data = @locale_data['games/game-detail']
      unless locale_data
        Jekyll.logger.error "LocaleGenerator:", "No locale data for 'games/game-detail'"
        return
      end
      
      @site.data['games'].each do |game|
        @languages.each { |lang| generate_game_detail_page(game, lang, locale_data) }
      end
    end
    
    # 生成单个游戏的详情页
    def generate_game_detail_page(game, lang, locale_data)
      title = game['title']&.dig(lang) || game['id']
      
      front_matter = {
        'layout' => 'game-wrapper',
        'lang' => lang,
        'title' => title,
        'game_id' => game['id'],
        'ref' => 'games/game-detail',
        'permalink' => "/#{lang}/games/#{game['id']}/",
        'translations' => build_translations_cached(locale_data, lang)
      }
      
      @site.pages << GameDetailPage.new(@site, @site.source, lang, game['id'], front_matter, "")
      @generated_count += 1
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
  
  # 游戏详情页类
  class GameDetailPage < Page
    def initialize(site, base, lang, game_id, front_matter, body)
      @site = site
      @base = base
      @dir = File.join(lang, 'games', game_id)
      @name = 'index.html'
      
      self.process(@name)
      
      # 设置内容
      self.content = body
      self.data = front_matter
    end
    
    # 读取方法（必需）
    def read_yaml(*)
      # 不需要读取，因为我们已经在初始化时设置了内容
    end
  end
  
  # Hook：为博客文章和其他页面注入翻译（从缓存读取）
  Hooks.register :posts, :pre_render do |post|
    next unless post.data['lang'] && post.site.data['translations']
    
    lang = post.data['lang']
    translations = post.data['translations'] ||= {}
    
    # 合并全局翻译到页面翻译中
    post.site.data['translations'].each do |key, value|
      translations[key] = value[lang] if value.is_a?(Hash) && value[lang]
    end
  end
  
  Hooks.register :pages, :pre_render do |page|
    next unless page.data['lang'] && page.site.data['translations']
    
    lang = page.data['lang']
    translations = page.data['translations'] ||= {}
    
    # 合并全局翻译到页面翻译中
    page.site.data['translations'].each do |key, value|
      translations[key] = value[lang] if value.is_a?(Hash) && value[lang]
    end
  end
end
