---
title: [PATCH] Create makedoc.yml & README.md badge
tags:
- linux
- github
- ci
---

github ci to auto-build linux htmldoc

.github/workflows/makedoc.yml | 32 ++++++++++++++++++++++++++++++++

``` diff
diff --git a/.github/workflows/makedoc.yml b/.github/workflows/makedoc.yml
new file mode 100644
index 000000000000..3f64fed87b73
--- /dev/null
+++ b/.github/workflows/makedoc.yml
@@ -0,0 +1,32 @@
+name: C/C++ CI
+
+on:
+- push
+- pull_request
+
+jobs:
+  build:
+
+    runs-on: ubuntu-latest
+
+    steps:
+    - uses: actions/checkout@v2.3.4
+      with:
+        # Repository name with owner. For example, actions/checkout
+        repository: ${{ github.repository }}
+    - name: Setup Python
+      uses: actions/setup-python@v2.2.1
+      with:
+      # Version range or exact version of a Python version to use, using SemVer's version range syntax.
+        python-version: 3.9
+    - name: apt install
+      run: |
+        sudo apt update
+        sudo apt-get install graphviz dvipng latexmk librsvg2-bin texlive-xetex
+    - name: pip
+      run: pip install -r ./Documentation/sphinx/requirements.txt
+    - name: makedoc
+      run: make htmldocs
+
+
+
```

