PACKAGE_NAME=properties

help: # Show this help

guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

commit: guard-msg format check # format code, check that quality is OK, then commit
	git add .
	git commit -m "$(msg)"

format: # apply as many suggested improvement as possible automatically
	autoflake -ri --remove-all-unused-imports $(PACKAGE_NAME)
	isort --profile=black $(PACKAGE_NAME)
	black $(PACKAGE_NAME)
	docformatter -ri $(PACKAGE_NAME)  #--pre-summary-newline

check: # check that all quality conditions required in MR are satisfied
	autoflake -r --remove-all-unused-imports $(PACKAGE_NAME)
	isort --check --profile=black $(PACKAGE_NAME)
	black --check $(PACKAGE_NAME)
	pydocstyle --convention=google $(PACKAGE_NAME)
	pylint --errors-only $(PACKAGE_NAME)

build-doc: # automatically build package documentation from docstrings
	rm -rf public/
	pdoc --html $(PACKAGE_NAME) -o tmp/
	mv tmp/$(PACKAGE_NAME) public/

show-doc: # open a webserver to preview documentation
	cd public && python -m http.server --bind localhost 5555
