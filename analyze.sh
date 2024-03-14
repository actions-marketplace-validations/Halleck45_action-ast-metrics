#!/bin/sh -l

set -e

# get version
if [ -z "${AST_METRICS_VERSION}" ]; then
    # default to latest
    AST_METRICS_VERSION="latest"
fi

if [ "${AST_METRICS_VERSION}" = "latest" ]; then
    # get latest version from github
    VERSION=$(curl -s https://api.github.com/repos/halleck45/ast-metrics/releases/latest|grep tag_name|cut -d '"' -f 4)
else
    # remove starting v if present
    AST_METRICS_VERSION=$(echo ${AST_METRICS_VERSION} | sed 's/^v//')
    VERSION=v{AST_METRICS_VERSION}
fi

# download and install
curl -L https://github.com/Halleck45/ast-metrics/releases/download/${VERSION}/ast-metrics_Linux_x86_64 -o /usr/local/bin/ast-metrics
chmod +x /usr/local/bin/ast-metrics

# analyze
if [[ -z "${DIRECTORY_TO_ANALYZE}" ]]; then
    echo "No path provided, using current directory"
    DIRECTORY_TO_ANALYZE="."
fi

if [[ -z "${REPORT_HTML_DIRECTORY}" ]]; then
    REPORT_HTML_DIRECTORY="ast-metrics-report"
fi

if [[ -z "${REPORT_MARKDOWN_FILENAME}" ]]; then
    REPORT_MARKDOWN_FILENAME="ast-metrics-report.md"
fi

# run
/usr/local/bin/ast-metrics analyze \
    --non-interactive \
    --report-html=${REPORT_HTML_DIRECTORY} \
    --report-markdown=${REPORT_MARKDOWN_FILENAME} \
    "${DIRECTORY_TO_ANALYZE}"

echo Finished