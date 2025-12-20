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
      
      # 加载 common.yml 并注入到 site.data
      load_common_translations
      
      # 处理所有模板文件
      template_files = find_template_files
      Jekyll.logger.info "LocaleGenerator:", "Found #{template_files.size} template files"
      
      @generated_count = 0
      template_files.each do |template_path|
        generate_pages_from_template(template_path)
      end
      
      # 为每个游戏生成详情页
      generate_game_detail_pages
      
      Jekyll.logger.info "LocaleGenerator:", "Generated #{@generated_count} pages"
    end

    private

    # 加载 common.yml 和 includes/*.yml 翻译
    # 返回分层结构：{ 'common' => {...}, 'header' => {...}, 'footer' => {...} }
    def load_common_translations
      translations = {
        'common' => {},
        'includes' => {}
      }
      
      # 1. 加载 common.yml
      common_file = File.join(@site.source, '_locale', 'common.yml')
      if File.exist?(common_file)
        begin
          common_data = YAML.load_file(common_file)
          translations['common'] = common_data
          Jekyll.logger.info "LocaleGenerator:", "Loaded common.yml with #{common_data.keys.size} keys"
        rescue => e
          Jekyll.logger.error "LocaleGenerator:", "Error loading common.yml: #{e.message}"
        end
      else
        Jekyll.logger.warn "LocaleGenerator:", "No common.yml found"
      end
      
      # 2. 加载 includes/*.yml
      includes_dir = File.join(@site.source, '_locale', 'includes')
      if Dir.exist?(includes_dir)
        include_count = 0
        Dir.glob(File.join(includes_dir, '*.yml')).each do |file|
          include_name = File.basename(file, '.yml')
          begin
            include_data = YAML.load_file(file)
            translations['includes'][include_name] = include_data
            
            include_count += 1
            Jekyll.logger.debug "LocaleGenerator:", "Loaded #{include_name}.yml with #{include_data.keys.size} keys"
          rescue => e
            Jekyll.logger.error "LocaleGenerator:", "Error loading #{file}: #{e.message}"
          end
        end
        Jekyll.logger.info "LocaleGenerator:", "Loaded #{include_count} include translation files"
      end
      
      # 保存到全局供生成页面时使用
      @common_translations = translations
    end

    # 加载所有 locale 数据
    def load_locale_data
      locale_data = {}
      locale_dir = File.join(@site.source, '_locale')
      
      return locale_data unless Dir.exist?(locale_dir)
      
      # 排除 common.yml（它单独处理）
      Dir.glob(File.join(locale_dir, '**', '*.yml')).each do |file|
        # 跳过 common.yml
        next if File.basename(file) == 'common.yml' && File.dirname(file) == locale_dir
        
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
      
      # 合并所有翻译到 page.translations
      new_front_matter['translations'] = build_translations(locale_data, lang)
      
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
    
    # 构建合并的翻译数据：页面特定 + common + includes
    def build_translations(locale_data, lang)
      translations = {}
      
      # 1. 加载页面特定翻译
      locale_data.each do |key, value|
        next if key == 'title' # title 已经单独处理
        if value.is_a?(Hash) && value[lang]
          translations[key] = value[lang]
        end
      end
      
      # 2. 加载 common.yml 翻译
      if @common_translations['common']
        @common_translations['common'].each do |key, value|
          translations[key] = value[lang] if value.is_a?(Hash) && value[lang]
        end
      end
      
      # 3. 加载 includes/*.yml 翻译（扁平化，不使用命名空间）
      if @common_translations['includes']
        @common_translations['includes'].each do |component_name, component_data|
          component_data.each do |key, value|
            translations[key] = value[lang] if value.is_a?(Hash) && value[lang]
          end
        end
      end
      
      translations
    end
    
    # 为每个游戏生成详情页
    def generate_game_detail_pages
      # 检查是否有游戏数据
      games = @site.data['games']
      unless games && games.any?
        Jekyll.logger.warn "LocaleGenerator:", "No games found in _data/games.yml"
        return
      end
      
      # 获取游戏详情页的 locale 数据
      locale_data = @locale_data['games/game-detail']
      unless locale_data
        Jekyll.logger.error "LocaleGenerator:", "No locale data for 'games/game-detail'"
        return
      end
      
      Jekyll.logger.info "LocaleGenerator:", "Generating game detail pages for #{games.size} games..."
      
      # 为每个游戏生成多语言页面
      games.each do |game|
        game_id = game['id']
        @languages.each do |lang|
          generate_game_detail_page(game, lang, locale_data)
        end
      end
    end
    
    # 生成单个游戏的详情页
    def generate_game_detail_page(game, lang, locale_data)
      game_id = game['id']
      
      # 获取游戏标题
      title = game['title'] ? game['title'][lang] : game_id
      
      # 构建 front matter
      front_matter = {
        'layout' => 'game-wrapper',
        'lang' => lang,
        'title' => title,
        'game_id' => game_id,
        'ref' => 'games/game-detail'
      }
      
      # 合并所有翻译到 page.translations
      front_matter['translations'] = build_translations(locale_data, lang)
      
      # 计算 permalink
      permalink = "/#{lang}/games/#{game_id}/"
      front_matter['permalink'] = permalink
      
      # 创建页面（空内容，由布局处理）
      body = ""
      
      # 创建 GameDetailPage 对象
      page = GameDetailPage.new(@site, @site.source, lang, game_id, front_matter, body)
      @site.pages << page
      
      @generated_count ||= 0
      @generated_count += 1
      
      Jekyll.logger.debug "LocaleGenerator:", "Generated game detail: #{lang}/games/#{game_id}/"
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
  
  # Hook：为博客文章和其他页面注入翻译
  class PostTranslationInjector
    def initialize(site)
      @site = site
      @common_translations = {}
      @locale_data = {}
      load_translations
    end
    
    def load_translations
      # 加载 common.yml
      common_file = File.join(@site.source, '_locale', 'common.yml')
      if File.exist?(common_file)
        @common_translations = YAML.load_file(common_file) || {}
      end
      
      # 加载 includes/*.yml
      includes_dir = File.join(@site.source, '_locale', 'includes')
      if Dir.exist?(includes_dir)
        Dir.glob(File.join(includes_dir, '*.yml')).each do |file|
          include_name = File.basename(file, '.yml')
          data = YAML.load_file(file) || {}
          @common_translations.merge!(data)
        end
      end
    end
    
    def inject_translations(page)
      return unless page.data['lang']
      
      lang = page.data['lang']
      translations = page.data['translations'] || {}
      
      # 合并 common 翻译
      @common_translations.each do |key, value|
        translations[key] = value[lang] if value.is_a?(Hash) && value[lang]
      end
      
      page.data['translations'] = translations
    end
  end
  
  # 在 Jekyll 处理页面时注入翻译
  Hooks.register :posts, :pre_render do |post|
    site = post.site
    injector = PostTranslationInjector.new(site)
    injector.inject_translations(post)
  end
  
  Hooks.register :pages, :pre_render do |page|
    site = page.site
    injector = PostTranslationInjector.new(site)
    injector.inject_translations(page)
  end
end
