PACKAGE_NAME=properties

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

guard-%: ## Ensure variable is defined
	@if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

##@ Code quality targets

format: ## apply as many suggested improvement as possible automatically
	autoflake -ri --remove-all-unused-imports $(PACKAGE_NAME)
	isort --profile=black $(PACKAGE_NAME)
	black $(PACKAGE_NAME)
	docformatter -ri $(PACKAGE_NAME)  #--pre-summary-newline

check: ## check that all quality conditions required in MR are satisfied
	autoflake -r --remove-all-unused-imports $(PACKAGE_NAME)
	isort --check --profile=black $(PACKAGE_NAME)
	black --check $(PACKAGE_NAME)
	pydocstyle --convention=google $(PACKAGE_NAME)
	pylint --errors-only $(PACKAGE_NAME)
	flake8 --max-line-length=120 $(PACKAGE_NAME)

##@ Versioning targets
mr: guard-title ## create branch and merge request from current branch
	...

commit: guard-msg format check ## format code, check that quality is OK, then commit
	git add .
	git commit -m "$(msg)"

merge: ## merge current branch into specified target if review is done, otherwise ask a review and exit 1
	...

##@ Documentation targets

build-doc: ## automatically build package documentation from docstrings
	rm -rf public/
	pdoc --html $(PACKAGE_NAME) -o tmp/
	mv tmp/$(PACKAGE_NAME) public/

show-doc: ## open a webserver to preview documentation
	cd public && python -m http.server --bind localhost 5555

death-regex:
	find infrapi -name '*.py' | xargs sed -i -r 's/"""([a-z])/"""\U\1/g'
	find infrapi -name '*.py' | xargs sed -ri 's/"""(.+)[^\.]"""/"""\1."""/g'
	find infrapi -name '*.py' | xargs sed -ri 's/"""(.+)[^\.]\n/"""\1.\n/g'