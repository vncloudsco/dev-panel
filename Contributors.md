# Quy Định Đóng Góp (Contributors Guidelines)

## Chào mừng bạn đến với dự án Panel Management Tool!

Cảm ơn bạn đã quan tâm đến việc đóng góp cho dự án này. Để đảm bảo chất lượng, bảo mật và tính nhất quán của dự án, vui lòng tuân thủ các quy định sau đây.

## 📋 Yêu Cầu Chung

### 1. Kiến Thức Cần Thiết
- Hiểu biết về Linux/Unix systems
- Kinh nghiệm với Nginx, MySQL/MariaDB, PHP
- Kiến thức về shell scripting (Bash)
- Hiểu về bảo mật server và web applications

### 2. Môi Trường Phát Triển
- Sử dụng hệ điều hành Linux Ubuntu 
- Test trên môi trường tách biệt trước khi submit

## 🔒 Yêu Cầu Bảo Mật

### A. Bảo Mật Mã Nguồn
1. **Không được chèn mã độc**
   - Tuyệt đối không chứa backdoor, malware, hoặc mã có thể gây hại
   - Không thu thập thông tin người dùng trái phép
   - Không tạo kết nối không mong muốn ra bên ngoài

2. **Kiểm tra Input/Output**
   - Validate tất cả input từ người dùng
   - Sanitize dữ liệu trước khi xử lý

3. **Quản lý Quyền Truy Cập**
   - Không hardcode credentials
   - Sử dụng least privilege principle
   - Kiểm tra quyền trước khi thực hiện operations

### B. Secure Coding Practices
```bash
# VÍ DỤ: Validate input
validate_domain() {
    local domain="$1"
    if [[ ! "$domain" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
        echo "Invalid domain format"
        exit 1
    fi
}

# VÍ DỤ: Secure file operations
create_config_file() {
    local config_file="$1"
    local temp_file=$(mktemp)
    
    # Write to temp file first
    cat > "$temp_file" << EOF
# Configuration content here
EOF
    
    # Move to final location with proper permissions
    sudo mv "$temp_file" "$config_file"
    sudo chmod 644 "$config_file"
    sudo chown root:root "$config_file"
}
```

## 📝 Quy Trình Đóng Góp

### 1. Trước Khi Bắt Đầu
- Fork repository này về tài khoản GitHub của bạn
- Clone fork về máy local
- Tạo branch mới cho feature/bugfix của bạn
- Đọc kỹ documentation và hiểu cấu trúc dự án

### 2. Phát Triển
```bash
# Tạo branch mới
git checkout -b feature/your-feature-name

# Hoặc cho bugfix
git checkout -b bugfix/issue-description
```

### 3. Testing Yêu Cầu
- **Bắt buộc**: Đã đươc kiểm tra trên Ubuntu
- Test với các phiên bản PHP khác nhau 7.4, 7.3.....
- Test backup/restore functionality
- Kiểm tra performance impact
- Test với SSL enabled/disabled

### 4. Code Review Checklist
- [ ] Không có hardcoded passwords/keys
- [ ] Tất cả functions đều có error handling
- [ ] Input validation được implement đầy đủ
- [ ] Logs không chứa sensitive information
- [ ] File permissions được set đúng cách
- [ ] Backward compatibility được duy trì
- [ ] Documentation được cập nhật

## 🚫 Các Hành Vi Bị Cấm

### 1. Mã Độc & Bảo Mật
- Chèn backdoor hoặc unauthorized access methods
- Thu thập credentials của người dùng
- Tạo network connections không được documentt
- Modify system files outside project scope
- Privilege escalation không cần thiết

### 2. Chất Lượng Code
- Copy-paste code từ nguồn không rõ ràng
- Hardcode sensitive data
- Ignore error conditions
- Write code không có comments
- Không follow coding standards

### 3. Quy Trình
- Direct push to main branch
- Submit PR không test
- Ignore code review feedback
- Không cập nhật documentation

## 📚 Cấu Trúc Dự Án

### Thư Mục Quan Trọng
- `menu/controller/`: Chứa logic chính cho các tính năng
- `menu/helpers/`: Functions và variables dùng chung
- `menu/template/`: Nginx configuration templates
- `menu/validate/`: Input validation functions
- `modules/`: External modules và dependencies

### Coding Standards
1. **Shell Scripts**:
   - Sử dụng `#!/bin/bash` cho compatibility
   - Quote variables: `"$variable"`
   - Check exit codes: `command || handle_error`
   - Use functions for reusable code

2. **Configuration Files**:
   - Comment rõ ràng purpose của mỗi directive
   - Sử dụng security headers
   - Optimize performance settings

## 🔍 Security Review Process

### Tự Kiểm Tra
```bash
# Kiểm tra permissions
find . -type f -perm /o+w -ls  # Không có world-writable files

# Kiểm tra hardcoded credentials
grep -r "password\|secret\|key" --include="*.sh" .

# Kiểm tra dangerous commands
grep -r "rm -rf\|dd if\|mkfs" --include="*.sh" .
```

### Báo Cáo Bảo Mật
Nếu phát hiện vulnerability:
1. **KHÔNG** tạo public issue
2. Email riêng cho maintainers
3. Cung cấp PoC (Proof of Concept)
4. Đợi patch trước khi public disclosure

## 📋 Pull Request Template

```markdown
## Mô Tả
Brief description of changes

## Loại Thay Đổi
- [ ] Bug fix
- [ ] New feature  
- [ ] Security improvement
- [ ] Documentation update
- [ ] Performance optimization

## Testing
- [ ] Tested on Ubuntu 20.04/22.04
- [ ] Tested with PHP 7.4/7.3
- [ ] Backup/restore functionality verified
- [ ] No security vulnerabilities introduced

## Security Checklist
- [ ] No hardcoded credentials
- [ ] Input validation implemented
- [ ] Error handling complete
- [ ] File permissions correct
- [ ] No unauthorized network access

## Breaking Changes
List any breaking changes
```

## 🏆 Recognition

Contributors sẽ được ghi nhận trong:
- CHANGELOG.md cho mỗi release
- Credits section trong documentation
- GitHub contributors list

## 📞 Liên Hệ

- GitHub Issues: Cho bugs và feature requests
- Security: Email riêng cho security issues

---

**Lưu ý**: Việc vi phạm các quy định bảo mật sẽ dẫn đến việc bị ban vĩnh viễn khỏi dự án. Chúng tôi có zero-tolerance policy với mã độc và các hành vi có thể gây hại đến người dùng.

Cảm ơn bạn đã đóng góp cho dự án! 🚀