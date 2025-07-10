# Branch Protection Rules

## Main Branch Protection

### Settings to Enable:

1. **Require a pull request before merging**

   - ✅ Require a pull request before merging
   - ✅ Require approvals: 1
   - ✅ Dismiss stale PR approvals when new commits are pushed
   - ✅ Require review from code owners

2. **Require status checks to pass before merging**

   - ✅ Require branches to be up to date before merging
   - ✅ Require status checks to pass before merging
   - Status checks to require:
     - `test` (CI/CD pipeline)
     - `lint` (Linting checks)
     - `security` (Security checks)

3. **Require conversation resolution before merging**

   - ✅ Require conversation resolution before merging

4. **Require signed commits**

   - ✅ Require signed commits

5. **Require linear history**

   - ✅ Require linear history

6. **Include administrators**

   - ✅ Include administrators

7. **Restrict pushes that create files that override the protection rules**
   - ✅ Restrict pushes that create files that override the protection rules

## Develop Branch Protection

### Settings to Enable:

1. **Require a pull request before merging**

   - ✅ Require a pull request before merging
   - ✅ Require approvals: 1
   - ✅ Dismiss stale PR approvals when new commits are pushed

2. **Require status checks to pass before merging**

   - ✅ Require branches to be up to date before merging
   - ✅ Require status checks to pass before merging
   - Status checks to require:
     - `test` (CI/CD pipeline)
     - `lint` (Linting checks)

3. **Require conversation resolution before merging**

   - ✅ Require conversation resolution before merging

4. **Include administrators**
   - ✅ Include administrators

## How to Set Up

1. Go to repository Settings
2. Navigate to Branches
3. Click "Add rule" for each branch (main, develop)
4. Configure the settings as listed above
5. Click "Create" to save the rules

## Code Owners

Create `.github/CODEOWNERS` file:

```
# Global owners
* @zafuss

# Specific file owners
lib/core/ @zafuss
lib/features/ @zafuss
test/ @zafuss
docs/ @zafuss

# Platform specific
android/ @zafuss
ios/ @zafuss
```

## Required Status Checks

The following status checks must pass before merging:

- **test**: Flutter tests, analysis, and build
- **lint**: Code formatting and linting
- **security**: Security checks for secrets and vulnerabilities

## Branch Naming Convention

Protected branches:

- `main` (production)
- `develop` (development)

Feature branches:

- `feature/feature-name`
- `bugfix/issue-description`
- `hotfix/critical-fix`
- `release/version`
- `docs/documentation-update`
