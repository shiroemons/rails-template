# .gitignore
run 'gibo macOS Ruby Rails JetBrains > .gitignore' rescue nil
gsub_file '.gitignore', /^config\/initializers\/secret_token.rb\n/, ''
gsub_file '.gitignore', /^config\/secrets.yml\n/, ''
