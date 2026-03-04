# Steps to release a new version of the renmods package

# Bump version
file.edit("DESCRIPTION")

# Add changes to NEWS
file.edit("NEWS.md")

# Standard checks
devtools::test() # Use Ctrl-Shift-T to test non-interactively
devtools::run_examples()
devtools::check()

# Additional quality checks
goodpractice::gp() # Checks for good practices
spelling::spell_check_package() # Check spelling in docs
urlchecker::url_check() # Check URLs in documentation

# Check docs
pkgdown::build_site()

# Platform checks
rhub::rhub_check() # Check on multiple platforms
devtools::check_win_devel() # Check on Windows R-devel

# Push changes
# Once CI clears, merge PR
# Create GitHub release
