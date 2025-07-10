# Commit Convention

## Conventional Commits

Chúng ta sử dụng [Conventional Commits](https://www.conventionalcommits.org/) để đảm bảo commit messages nhất quán và có thể tự động generate changelog.

### Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- **feat**: Tính năng mới
- **fix**: Sửa lỗi
- **docs**: Thay đổi documentation
- **style**: Thay đổi không ảnh hưởng đến code (formatting, missing semi colons, etc)
- **refactor**: Refactor code production
- **test**: Thêm hoặc sửa test
- **chore**: Thay đổi build process hoặc auxiliary tools
- **perf**: Cải thiện performance
- **ci**: Thay đổi CI configuration files
- **build**: Thay đổi build system hoặc external dependencies

### Scopes (Optional)

- **ui**: User Interface
- **auth**: Authentication
- **api**: API related
- **db**: Database
- **test**: Testing
- **docs**: Documentation
- **deps**: Dependencies

### Examples

```bash
# Feature
git commit -m "feat(auth): add biometric authentication"

# Bug fix
git commit -m "fix(ui): resolve navigation bar overlap issue"

# Documentation
git commit -m "docs: update API documentation"

# Refactor
git commit -m "refactor(core): optimize note search algorithm"

# Test
git commit -m "test: add unit tests for note validation"

# Breaking change
git commit -m "feat(api)!: change note creation endpoint

BREAKING CHANGE: The note creation endpoint now requires user_id parameter"
```

### Breaking Changes

Sử dụng `!` sau type để đánh dấu breaking change:

```
feat!: breaking change
fix!: breaking fix
```

### Commit Message Guidelines

1. **Sử dụng imperative mood**: "add" thay vì "added" hoặc "adds"
2. **Không kết thúc bằng dấu chấm**
3. **Giới hạn dòng đầu tiên 72 ký tự**
4. **Sử dụng body để giải thích chi tiết**
5. **Sử dụng footer để reference issues**

### Examples với Body và Footer

```bash
git commit -m "feat(notes): implement AI-powered note summarization

- Add OpenAI API integration
- Implement summarization algorithm
- Add progress indicators
- Handle API rate limiting

Closes #123
Fixes #456"
```

## Pre-commit Hooks

Chúng ta sử dụng pre-commit hooks để đảm bảo code quality:

1. **Lint check**: Kiểm tra Dart/Flutter linting rules
2. **Format check**: Đảm bảo code được format đúng
3. **Test check**: Chạy unit tests trước khi commit
4. **Commit message check**: Validate commit message format

## Commit Template

Tạo file `.gitmessage` trong project root:

```
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>
```

Sử dụng template:

```bash
git config commit.template .gitmessage
```

## Automated Changelog

Chúng ta sử dụng [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) để tự động generate changelog từ commit messages.

## Branch Naming Convention

- `feature/feature-name`: Tính năng mới
- `bugfix/issue-description`: Sửa lỗi
- `hotfix/critical-fix`: Sửa lỗi khẩn cấp
- `release/version`: Release preparation
- `docs/documentation-update`: Cập nhật documentation

## Pull Request Guidelines

1. **Title**: Sử dụng conventional commit format
2. **Description**: Mô tả chi tiết thay đổi
3. **Linked Issues**: Reference related issues
4. **Screenshots**: Nếu có UI changes
5. **Testing**: Mô tả cách test thay đổi
