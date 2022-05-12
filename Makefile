format:
	autoflake -ri --remove-all-unused-imports properties
	isort --profile=black properties
	black properties
	docformatter -ri --pre-summary-newline properties/
