#!/usr/bin/env ruby
# encoding: utf-8

# 开发模式：监听 _templates/ 目录变化并自动重新生成页面
# 使用 gem 'listen' 监听文件变化

require 'listen'
require 'fileutils'

# 颜色输出
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def log_info(message)
  puts colorize("[INFO] #{message}", 34)
end

def log_success(message)
  puts colorize("[SUCCESS] #{message}", 32)
end

def log_error(message)
  puts colorize("[ERROR] #{message}", 31)
end

# 运行生成脚本
def run_generation
  log_info "Regenerating pages..."
  system("ruby scripts/generate_pages.rb")
  puts "\n"
end

# 主函数
def main
  log_info "Starting development watcher..."
  log_info "Watching _templates/ and _locale/ directories for changes"
  log_info "Press Ctrl+C to stop"
  puts "\n"
  
  # 初始生成
  run_generation
  
  # 监听文件变化
  listener = Listen.to('_templates', '_locale') do |modified, added, removed|
    if (modified + added + removed).any?
      log_info "Detected file changes:"
      (modified + added + removed).each { |f| puts "  - #{f}" }
      run_generation
    end
  end
  
  listener.start
  
  # 保持运行
  sleep
rescue Interrupt
  log_info "\nStopping watcher..."
  exit 0
rescue LoadError
  log_error "The 'listen' gem is not installed."
  log_info "Install it with: gem install listen"
  exit 1
end

if __FILE__ == $0
  main
end
