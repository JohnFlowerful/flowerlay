# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Pterodactyl® is a free, open-source game server management panel built with PHP, React, and Go."
HOMEPAGE="https://pterodactyl.io/"

SRC_URI="
	https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.12.11.tgz -> @babel-code-frame-7.12.11.tgz
	https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.5.5.tgz -> @babel-code-frame-7.5.5.tgz
	https://registry.yarnpkg.com/@babel/code-frame/-/code-frame-7.10.4.tgz -> @babel-code-frame-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/compat-data/-/compat-data-7.12.1.tgz -> @babel-compat-data-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/core/-/core-7.12.3.tgz -> @babel-core-7.12.3.tgz
	https://registry.yarnpkg.com/@babel/generator/-/generator-7.10.4.tgz -> @babel-generator-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/generator/-/generator-7.12.1.tgz -> @babel-generator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.7.4.tgz -> @babel-helper-annotate-as-pure-7.7.4.tgz
	https://registry.yarnpkg.com/@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.10.4.tgz -> @babel-helper-annotate-as-pure-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.10.4.tgz -> @babel-helper-builder-binary-assignment-operator-visitor-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-builder-react-jsx-experimental/-/helper-builder-react-jsx-experimental-7.12.1.tgz -> @babel-helper-builder-react-jsx-experimental-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-builder-react-jsx/-/helper-builder-react-jsx-7.10.4.tgz -> @babel-helper-builder-react-jsx-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-compilation-targets/-/helper-compilation-targets-7.12.1.tgz -> @babel-helper-compilation-targets-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.12.1.tgz -> @babel-helper-create-class-features-plugin-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.12.1.tgz -> @babel-helper-create-regexp-features-plugin-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-define-map/-/helper-define-map-7.10.5.tgz -> @babel-helper-define-map-7.10.5.tgz
	https://registry.yarnpkg.com/@babel/helper-explode-assignable-expression/-/helper-explode-assignable-expression-7.12.1.tgz -> @babel-helper-explode-assignable-expression-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-function-name/-/helper-function-name-7.10.4.tgz -> @babel-helper-function-name-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-get-function-arity/-/helper-get-function-arity-7.10.4.tgz -> @babel-helper-get-function-arity-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-hoist-variables/-/helper-hoist-variables-7.10.4.tgz -> @babel-helper-hoist-variables-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.12.1.tgz -> @babel-helper-member-expression-to-functions-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.7.4.tgz -> @babel-helper-module-imports-7.7.4.tgz
	https://registry.yarnpkg.com/@babel/helper-module-imports/-/helper-module-imports-7.12.1.tgz -> @babel-helper-module-imports-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-module-transforms/-/helper-module-transforms-7.12.1.tgz -> @babel-helper-module-transforms-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.10.4.tgz -> @babel-helper-optimise-call-expression-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.0.0.tgz -> @babel-helper-plugin-utils-7.0.0.tgz
	https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.10.4.tgz -> @babel-helper-plugin-utils-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-plugin-utils/-/helper-plugin-utils-7.8.3.tgz -> @babel-helper-plugin-utils-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/helper-regex/-/helper-regex-7.10.5.tgz -> @babel-helper-regex-7.10.5.tgz
	https://registry.yarnpkg.com/@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.12.1.tgz -> @babel-helper-remap-async-to-generator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-replace-supers/-/helper-replace-supers-7.12.1.tgz -> @babel-helper-replace-supers-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-simple-access/-/helper-simple-access-7.12.1.tgz -> @babel-helper-simple-access-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.12.1.tgz -> @babel-helper-skip-transparent-expression-wrappers-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.10.4.tgz -> @babel-helper-split-export-declaration-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.11.0.tgz -> @babel-helper-split-export-declaration-7.11.0.tgz
	https://registry.yarnpkg.com/@babel/helper-validator-identifier/-/helper-validator-identifier-7.10.4.tgz -> @babel-helper-validator-identifier-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/helper-validator-option/-/helper-validator-option-7.12.1.tgz -> @babel-helper-validator-option-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/helper-wrap-function/-/helper-wrap-function-7.12.3.tgz -> @babel-helper-wrap-function-7.12.3.tgz
	https://registry.yarnpkg.com/@babel/helpers/-/helpers-7.12.1.tgz -> @babel-helpers-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.0.0.tgz -> @babel-highlight-7.0.0.tgz
	https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.10.4.tgz -> @babel-highlight-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/parser/-/parser-7.10.4.tgz -> @babel-parser-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/parser/-/parser-7.12.3.tgz -> @babel-parser-7.12.3.tgz
	https://registry.yarnpkg.com/@babel/parser/-/parser-7.12.11.tgz -> @babel-parser-7.12.11.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-async-generator-functions/-/plugin-proposal-async-generator-functions-7.12.1.tgz -> @babel-plugin-proposal-async-generator-functions-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-class-properties/-/plugin-proposal-class-properties-7.12.1.tgz -> @babel-plugin-proposal-class-properties-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-dynamic-import/-/plugin-proposal-dynamic-import-7.12.1.tgz -> @babel-plugin-proposal-dynamic-import-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-export-namespace-from/-/plugin-proposal-export-namespace-from-7.12.1.tgz -> @babel-plugin-proposal-export-namespace-from-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-json-strings/-/plugin-proposal-json-strings-7.12.1.tgz -> @babel-plugin-proposal-json-strings-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-logical-assignment-operators/-/plugin-proposal-logical-assignment-operators-7.12.1.tgz -> @babel-plugin-proposal-logical-assignment-operators-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-nullish-coalescing-operator/-/plugin-proposal-nullish-coalescing-operator-7.12.1.tgz -> @babel-plugin-proposal-nullish-coalescing-operator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-numeric-separator/-/plugin-proposal-numeric-separator-7.12.1.tgz -> @babel-plugin-proposal-numeric-separator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-object-rest-spread/-/plugin-proposal-object-rest-spread-7.12.1.tgz -> @babel-plugin-proposal-object-rest-spread-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-optional-catch-binding/-/plugin-proposal-optional-catch-binding-7.12.1.tgz -> @babel-plugin-proposal-optional-catch-binding-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-optional-chaining/-/plugin-proposal-optional-chaining-7.12.1.tgz -> @babel-plugin-proposal-optional-chaining-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-private-methods/-/plugin-proposal-private-methods-7.12.1.tgz -> @babel-plugin-proposal-private-methods-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-proposal-unicode-property-regex/-/plugin-proposal-unicode-property-regex-7.12.1.tgz -> @babel-plugin-proposal-unicode-property-regex-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz -> @babel-plugin-syntax-async-generators-7.8.4.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.1.tgz -> @babel-plugin-syntax-class-properties-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz -> @babel-plugin-syntax-dynamic-import-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz -> @babel-plugin-syntax-export-namespace-from-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz -> @babel-plugin-syntax-json-strings-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-jsx/-/plugin-syntax-jsx-7.12.1.tgz -> @babel-plugin-syntax-jsx-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz -> @babel-plugin-syntax-logical-assignment-operators-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz -> @babel-plugin-syntax-nullish-coalescing-operator-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz -> @babel-plugin-syntax-numeric-separator-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz -> @babel-plugin-syntax-object-rest-spread-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz -> @babel-plugin-syntax-optional-catch-binding-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz -> @babel-plugin-syntax-optional-chaining-7.8.3.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.12.1.tgz -> @babel-plugin-syntax-top-level-await-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-syntax-typescript/-/plugin-syntax-typescript-7.12.1.tgz -> @babel-plugin-syntax-typescript-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.12.1.tgz -> @babel-plugin-transform-arrow-functions-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.12.1.tgz -> @babel-plugin-transform-async-to-generator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.12.1.tgz -> @babel-plugin-transform-block-scoped-functions-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.12.1.tgz -> @babel-plugin-transform-block-scoping-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-classes/-/plugin-transform-classes-7.12.1.tgz -> @babel-plugin-transform-classes-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.12.1.tgz -> @babel-plugin-transform-computed-properties-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.12.1.tgz -> @babel-plugin-transform-destructuring-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.12.1.tgz -> @babel-plugin-transform-dotall-regex-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.12.1.tgz -> @babel-plugin-transform-duplicate-keys-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.12.1.tgz -> @babel-plugin-transform-exponentiation-operator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.12.1.tgz -> @babel-plugin-transform-for-of-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.12.1.tgz -> @babel-plugin-transform-function-name-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-literals/-/plugin-transform-literals-7.12.1.tgz -> @babel-plugin-transform-literals-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.12.1.tgz -> @babel-plugin-transform-member-expression-literals-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.12.1.tgz -> @babel-plugin-transform-modules-amd-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.12.1.tgz -> @babel-plugin-transform-modules-commonjs-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.12.1.tgz -> @babel-plugin-transform-modules-systemjs-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.12.1.tgz -> @babel-plugin-transform-modules-umd-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.12.1.tgz -> @babel-plugin-transform-named-capturing-groups-regex-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.12.1.tgz -> @babel-plugin-transform-new-target-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.12.1.tgz -> @babel-plugin-transform-object-super-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.12.1.tgz -> @babel-plugin-transform-parameters-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.12.1.tgz -> @babel-plugin-transform-property-literals-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-display-name/-/plugin-transform-react-display-name-7.12.1.tgz -> @babel-plugin-transform-react-display-name-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx-development/-/plugin-transform-react-jsx-development-7.12.1.tgz -> @babel-plugin-transform-react-jsx-development-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx-self/-/plugin-transform-react-jsx-self-7.12.1.tgz -> @babel-plugin-transform-react-jsx-self-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx-source/-/plugin-transform-react-jsx-source-7.12.1.tgz -> @babel-plugin-transform-react-jsx-source-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-jsx/-/plugin-transform-react-jsx-7.12.1.tgz -> @babel-plugin-transform-react-jsx-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-react-pure-annotations/-/plugin-transform-react-pure-annotations-7.12.1.tgz -> @babel-plugin-transform-react-pure-annotations-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.12.1.tgz -> @babel-plugin-transform-regenerator-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.12.1.tgz -> @babel-plugin-transform-reserved-words-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-runtime/-/plugin-transform-runtime-7.12.1.tgz -> @babel-plugin-transform-runtime-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.12.1.tgz -> @babel-plugin-transform-shorthand-properties-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-spread/-/plugin-transform-spread-7.12.1.tgz -> @babel-plugin-transform-spread-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.12.1.tgz -> @babel-plugin-transform-sticky-regex-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.12.1.tgz -> @babel-plugin-transform-template-literals-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.12.1.tgz -> @babel-plugin-transform-typeof-symbol-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-typescript/-/plugin-transform-typescript-7.12.1.tgz -> @babel-plugin-transform-typescript-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.12.1.tgz -> @babel-plugin-transform-unicode-escapes-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.12.1.tgz -> @babel-plugin-transform-unicode-regex-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/preset-env/-/preset-env-7.12.1.tgz -> @babel-preset-env-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/preset-modules/-/preset-modules-0.1.4.tgz -> @babel-preset-modules-0.1.4.tgz
	https://registry.yarnpkg.com/@babel/preset-react/-/preset-react-7.12.1.tgz -> @babel-preset-react-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/preset-typescript/-/preset-typescript-7.12.1.tgz -> @babel-preset-typescript-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.7.5.tgz -> @babel-runtime-7.7.5.tgz
	https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.12.1.tgz -> @babel-runtime-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/runtime/-/runtime-7.10.4.tgz -> @babel-runtime-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/template/-/template-7.10.4.tgz -> @babel-template-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.12.1.tgz -> @babel-traverse-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/traverse/-/traverse-7.10.4.tgz -> @babel-traverse-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/types/-/types-7.10.4.tgz -> @babel-types-7.10.4.tgz
	https://registry.yarnpkg.com/@babel/types/-/types-7.12.1.tgz -> @babel-types-7.12.1.tgz
	https://registry.yarnpkg.com/@babel/types/-/types-7.7.4.tgz -> @babel-types-7.7.4.tgz
	https://registry.yarnpkg.com/@emotion/is-prop-valid/-/is-prop-valid-0.8.8.tgz -> @emotion-is-prop-valid-0.8.8.tgz
	https://registry.yarnpkg.com/@emotion/memoize/-/memoize-0.7.4.tgz -> @emotion-memoize-0.7.4.tgz
	https://registry.yarnpkg.com/@emotion/stylis/-/stylis-0.8.5.tgz -> @emotion-stylis-0.8.5.tgz
	https://registry.yarnpkg.com/@emotion/unitless/-/unitless-0.7.5.tgz -> @emotion-unitless-0.7.5.tgz
	https://registry.yarnpkg.com/@eslint/eslintrc/-/eslintrc-0.4.1.tgz -> @eslint-eslintrc-0.4.1.tgz
	https://registry.yarnpkg.com/@fortawesome/fontawesome-common-types/-/fontawesome-common-types-0.2.32.tgz -> @fortawesome-fontawesome-common-types-0.2.32.tgz
	https://registry.yarnpkg.com/@fortawesome/fontawesome-svg-core/-/fontawesome-svg-core-1.2.32.tgz -> @fortawesome-fontawesome-svg-core-1.2.32.tgz
	https://registry.yarnpkg.com/@fortawesome/free-solid-svg-icons/-/free-solid-svg-icons-5.15.1.tgz -> @fortawesome-free-solid-svg-icons-5.15.1.tgz
	https://registry.yarnpkg.com/@fortawesome/react-fontawesome/-/react-fontawesome-0.1.11.tgz -> @fortawesome-react-fontawesome-0.1.11.tgz
	https://registry.yarnpkg.com/@fullhuman/postcss-purgecss/-/postcss-purgecss-3.1.3.tgz -> @fullhuman-postcss-purgecss-3.1.3.tgz
	https://registry.yarnpkg.com/@nodelib/fs.scandir/-/fs.scandir-2.1.4.tgz -> @nodelib-fs.scandir-2.1.4.tgz
	https://registry.yarnpkg.com/@nodelib/fs.stat/-/fs.stat-2.0.4.tgz -> @nodelib-fs.stat-2.0.4.tgz
	https://registry.yarnpkg.com/@nodelib/fs.walk/-/fs.walk-1.2.6.tgz -> @nodelib-fs.walk-1.2.6.tgz
	https://registry.yarnpkg.com/@npmcli/move-file/-/move-file-1.0.1.tgz -> @npmcli-move-file-1.0.1.tgz
	https://registry.yarnpkg.com/@tailwindcss/forms/-/forms-0.2.1.tgz -> @tailwindcss-forms-0.2.1.tgz
	https://registry.yarnpkg.com/@types/chart.js/-/chart.js-2.8.5.tgz -> @types-chart.js-2.8.5.tgz
	https://registry.yarnpkg.com/@types/codemirror/-/codemirror-0.0.98.tgz -> @types-codemirror-0.0.98.tgz
	https://registry.yarnpkg.com/@types/color-name/-/color-name-1.1.1.tgz -> @types-color-name-1.1.1.tgz
	https://registry.yarnpkg.com/@types/debounce/-/debounce-1.2.0.tgz -> @types-debounce-1.2.0.tgz
	https://registry.yarnpkg.com/@types/estree/-/estree-0.0.45.tgz -> @types-estree-0.0.45.tgz
	https://registry.yarnpkg.com/@types/events/-/events-3.0.0.tgz -> @types-events-3.0.0.tgz
	https://registry.yarnpkg.com/@types/glob/-/glob-7.1.1.tgz -> @types-glob-7.1.1.tgz
	https://registry.yarnpkg.com/@types/history/-/history-4.7.2.tgz -> @types-history-4.7.2.tgz
	https://registry.yarnpkg.com/@types/hoist-non-react-statics/-/hoist-non-react-statics-3.3.1.tgz -> @types-hoist-non-react-statics-3.3.1.tgz
	https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.4.tgz -> @types-json-schema-7.0.4.tgz
	https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.5.tgz -> @types-json-schema-7.0.5.tgz
	https://registry.yarnpkg.com/@types/json-schema/-/json-schema-7.0.7.tgz -> @types-json-schema-7.0.7.tgz
	https://registry.yarnpkg.com/@types/json5/-/json5-0.0.29.tgz -> @types-json5-0.0.29.tgz
	https://registry.yarnpkg.com/@types/minimatch/-/minimatch-3.0.3.tgz -> @types-minimatch-3.0.3.tgz
	https://registry.yarnpkg.com/@types/node/-/node-12.6.9.tgz -> @types-node-12.6.9.tgz
	https://registry.yarnpkg.com/@types/node/-/node-14.11.10.tgz -> @types-node-14.11.10.tgz
	https://registry.yarnpkg.com/@types/parse-json/-/parse-json-4.0.0.tgz -> @types-parse-json-4.0.0.tgz
	https://registry.yarnpkg.com/@types/prop-types/-/prop-types-15.7.1.tgz -> @types-prop-types-15.7.1.tgz
	https://registry.yarnpkg.com/@types/qrcode.react/-/qrcode.react-1.0.1.tgz -> @types-qrcode.react-1.0.1.tgz
	https://registry.yarnpkg.com/@types/query-string/-/query-string-6.3.0.tgz -> @types-query-string-6.3.0.tgz
	https://registry.yarnpkg.com/@types/react-copy-to-clipboard/-/react-copy-to-clipboard-4.3.0.tgz -> @types-react-copy-to-clipboard-4.3.0.tgz
	https://registry.yarnpkg.com/@types/react-dom/-/react-dom-16.9.8.tgz -> @types-react-dom-16.9.8.tgz
	https://registry.yarnpkg.com/@types/react-helmet/-/react-helmet-6.0.0.tgz -> @types-react-helmet-6.0.0.tgz
	https://registry.yarnpkg.com/@types/react-redux/-/react-redux-7.1.1.tgz -> @types-react-redux-7.1.1.tgz
	https://registry.yarnpkg.com/@types/react-router-dom/-/react-router-dom-5.1.3.tgz -> @types-react-router-dom-5.1.3.tgz
	https://registry.yarnpkg.com/@types/react-router/-/react-router-5.1.3.tgz -> @types-react-router-5.1.3.tgz
	https://registry.yarnpkg.com/@types/react-transition-group/-/react-transition-group-4.4.0.tgz -> @types-react-transition-group-4.4.0.tgz
	https://registry.yarnpkg.com/@types/react/-/react-16.9.15.tgz -> @types-react-16.9.15.tgz
	https://registry.yarnpkg.com/@types/react/-/react-16.9.41.tgz -> @types-react-16.9.41.tgz
	https://registry.yarnpkg.com/@types/styled-components/-/styled-components-5.1.7.tgz -> @types-styled-components-5.1.7.tgz
	https://registry.yarnpkg.com/@types/tern/-/tern-0.23.3.tgz -> @types-tern-0.23.3.tgz
	https://registry.yarnpkg.com/@types/uuid/-/uuid-3.4.5.tgz -> @types-uuid-3.4.5.tgz
	https://registry.yarnpkg.com/@types/webpack-env/-/webpack-env-1.15.2.tgz -> @types-webpack-env-1.15.2.tgz
	https://registry.yarnpkg.com/@types/yup/-/yup-0.29.3.tgz -> @types-yup-0.29.3.tgz
	https://registry.yarnpkg.com/@typescript-eslint/eslint-plugin/-/eslint-plugin-4.25.0.tgz -> @typescript-eslint-eslint-plugin-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/experimental-utils/-/experimental-utils-4.25.0.tgz -> @typescript-eslint-experimental-utils-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/parser/-/parser-4.25.0.tgz -> @typescript-eslint-parser-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/scope-manager/-/scope-manager-4.25.0.tgz -> @typescript-eslint-scope-manager-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/types/-/types-4.25.0.tgz -> @typescript-eslint-types-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/typescript-estree/-/typescript-estree-4.25.0.tgz -> @typescript-eslint-typescript-estree-4.25.0.tgz
	https://registry.yarnpkg.com/@typescript-eslint/visitor-keys/-/visitor-keys-4.25.0.tgz -> @typescript-eslint-visitor-keys-4.25.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/ast/-/ast-1.9.0.tgz -> @webassemblyjs-ast-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/floating-point-hex-parser/-/floating-point-hex-parser-1.9.0.tgz -> @webassemblyjs-floating-point-hex-parser-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-api-error/-/helper-api-error-1.9.0.tgz -> @webassemblyjs-helper-api-error-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-buffer/-/helper-buffer-1.9.0.tgz -> @webassemblyjs-helper-buffer-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-code-frame/-/helper-code-frame-1.9.0.tgz -> @webassemblyjs-helper-code-frame-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-fsm/-/helper-fsm-1.9.0.tgz -> @webassemblyjs-helper-fsm-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-module-context/-/helper-module-context-1.9.0.tgz -> @webassemblyjs-helper-module-context-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-bytecode/-/helper-wasm-bytecode-1.9.0.tgz -> @webassemblyjs-helper-wasm-bytecode-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/helper-wasm-section/-/helper-wasm-section-1.9.0.tgz -> @webassemblyjs-helper-wasm-section-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/ieee754/-/ieee754-1.9.0.tgz -> @webassemblyjs-ieee754-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/leb128/-/leb128-1.9.0.tgz -> @webassemblyjs-leb128-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/utf8/-/utf8-1.9.0.tgz -> @webassemblyjs-utf8-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wasm-edit/-/wasm-edit-1.9.0.tgz -> @webassemblyjs-wasm-edit-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wasm-gen/-/wasm-gen-1.9.0.tgz -> @webassemblyjs-wasm-gen-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wasm-opt/-/wasm-opt-1.9.0.tgz -> @webassemblyjs-wasm-opt-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wasm-parser/-/wasm-parser-1.9.0.tgz -> @webassemblyjs-wasm-parser-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wast-parser/-/wast-parser-1.9.0.tgz -> @webassemblyjs-wast-parser-1.9.0.tgz
	https://registry.yarnpkg.com/@webassemblyjs/wast-printer/-/wast-printer-1.9.0.tgz -> @webassemblyjs-wast-printer-1.9.0.tgz
	https://registry.yarnpkg.com/@xtuc/ieee754/-/ieee754-1.2.0.tgz -> @xtuc-ieee754-1.2.0.tgz
	https://registry.yarnpkg.com/@xtuc/long/-/long-4.2.2.tgz -> @xtuc-long-4.2.2.tgz
	https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.1.0.tgz -> @yarnpkg-lockfile-1.1.0.tgz
	https://registry.yarnpkg.com/abab/-/abab-2.0.3.tgz
	https://registry.yarnpkg.com/abbrev/-/abbrev-1.1.1.tgz
	https://registry.yarnpkg.com/accepts/-/accepts-1.3.7.tgz
	https://registry.yarnpkg.com/acorn-jsx/-/acorn-jsx-5.3.1.tgz
	https://registry.yarnpkg.com/acorn-node/-/acorn-node-1.8.2.tgz
	https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-7.2.0.tgz
	https://registry.yarnpkg.com/acorn/-/acorn-6.4.1.tgz
	https://registry.yarnpkg.com/acorn/-/acorn-7.3.1.tgz
	https://registry.yarnpkg.com/acorn/-/acorn-7.4.1.tgz
	https://registry.yarnpkg.com/aggregate-error/-/aggregate-error-3.0.1.tgz
	https://registry.yarnpkg.com/ajv-errors/-/ajv-errors-1.0.1.tgz
	https://registry.yarnpkg.com/ajv-keywords/-/ajv-keywords-3.4.1.tgz
	https://registry.yarnpkg.com/ajv/-/ajv-6.10.2.tgz
	https://registry.yarnpkg.com/ajv/-/ajv-6.12.2.tgz
	https://registry.yarnpkg.com/ajv/-/ajv-6.12.6.tgz
	https://registry.yarnpkg.com/ajv/-/ajv-8.5.0.tgz
	https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-3.2.3.tgz
	https://registry.yarnpkg.com/ansi-colors/-/ansi-colors-4.1.1.tgz
	https://registry.yarnpkg.com/ansi-html/-/ansi-html-0.0.7.tgz
	https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-2.1.1.tgz
	https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-3.0.0.tgz
	https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-4.1.0.tgz
	https://registry.yarnpkg.com/ansi-regex/-/ansi-regex-5.0.0.tgz
	https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-3.2.1.tgz
	https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.3.0.tgz
	https://registry.yarnpkg.com/ansi-styles/-/ansi-styles-4.2.1.tgz
	https://registry.yarnpkg.com/anymatch/-/anymatch-2.0.0.tgz
	https://registry.yarnpkg.com/anymatch/-/anymatch-3.1.1.tgz
	https://registry.yarnpkg.com/aproba/-/aproba-1.2.0.tgz
	https://registry.yarnpkg.com/are-we-there-yet/-/are-we-there-yet-1.1.5.tgz
	https://registry.yarnpkg.com/argparse/-/argparse-1.0.10.tgz
	https://registry.yarnpkg.com/arr-diff/-/arr-diff-4.0.0.tgz
	https://registry.yarnpkg.com/arr-flatten/-/arr-flatten-1.1.0.tgz
	https://registry.yarnpkg.com/arr-union/-/arr-union-3.1.0.tgz
	https://registry.yarnpkg.com/array-flatten/-/array-flatten-1.1.1.tgz
	https://registry.yarnpkg.com/array-flatten/-/array-flatten-2.1.2.tgz
	https://registry.yarnpkg.com/array-includes/-/array-includes-3.1.3.tgz
	https://registry.yarnpkg.com/array-union/-/array-union-1.0.2.tgz
	https://registry.yarnpkg.com/array-union/-/array-union-2.1.0.tgz
	https://registry.yarnpkg.com/array-uniq/-/array-uniq-1.0.3.tgz
	https://registry.yarnpkg.com/array-unique/-/array-unique-0.3.2.tgz
	https://registry.yarnpkg.com/array.prototype.flat/-/array.prototype.flat-1.2.4.tgz
	https://registry.yarnpkg.com/array.prototype.flatmap/-/array.prototype.flatmap-1.2.4.tgz
	https://registry.yarnpkg.com/asn1.js/-/asn1.js-4.10.1.tgz
	https://registry.yarnpkg.com/assert/-/assert-1.4.1.tgz
	https://registry.yarnpkg.com/assign-symbols/-/assign-symbols-1.0.0.tgz
	https://registry.yarnpkg.com/astral-regex/-/astral-regex-2.0.0.tgz
	https://registry.yarnpkg.com/async-each/-/async-each-1.0.1.tgz
	https://registry.yarnpkg.com/async-limiter/-/async-limiter-1.0.0.tgz
	https://registry.yarnpkg.com/async/-/async-2.6.3.tgz
	https://registry.yarnpkg.com/at-least-node/-/at-least-node-1.0.0.tgz
	https://registry.yarnpkg.com/atob/-/atob-2.1.1.tgz
	https://registry.yarnpkg.com/autoprefixer/-/autoprefixer-10.1.0.tgz
	https://registry.yarnpkg.com/axios/-/axios-0.21.1.tgz
	https://registry.yarnpkg.com/babel-loader/-/babel-loader-8.0.6.tgz
	https://registry.yarnpkg.com/babel-plugin-dynamic-import-node/-/babel-plugin-dynamic-import-node-2.3.3.tgz
	https://registry.yarnpkg.com/babel-plugin-macros/-/babel-plugin-macros-2.8.0.tgz
	https://registry.yarnpkg.com/babel-plugin-styled-components/-/babel-plugin-styled-components-1.10.6.tgz
	https://registry.yarnpkg.com/babel-plugin-styled-components/-/babel-plugin-styled-components-1.12.0.tgz
	https://registry.yarnpkg.com/babel-plugin-syntax-jsx/-/babel-plugin-syntax-jsx-6.18.0.tgz
	https://registry.yarnpkg.com/babel-runtime/-/babel-runtime-6.26.0.tgz
	https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.0.tgz
	https://registry.yarnpkg.com/base64-js/-/base64-js-1.3.0.tgz
	https://registry.yarnpkg.com/base/-/base-0.11.2.tgz
	https://registry.yarnpkg.com/batch/-/batch-0.6.1.tgz
	https://registry.yarnpkg.com/bfj/-/bfj-6.1.2.tgz
	https://registry.yarnpkg.com/big.js/-/big.js-5.2.2.tgz
	https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-1.11.0.tgz
	https://registry.yarnpkg.com/binary-extensions/-/binary-extensions-2.1.0.tgz
	https://registry.yarnpkg.com/bluebird/-/bluebird-3.5.5.tgz
	https://registry.yarnpkg.com/bn.js/-/bn.js-4.11.8.tgz
	https://registry.yarnpkg.com/body-parser/-/body-parser-1.19.0.tgz
	https://registry.yarnpkg.com/bonjour/-/bonjour-3.5.0.tgz
	https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz
	https://registry.yarnpkg.com/braces/-/braces-2.3.2.tgz
	https://registry.yarnpkg.com/braces/-/braces-3.0.2.tgz
	https://registry.yarnpkg.com/brorand/-/brorand-1.1.0.tgz
	https://registry.yarnpkg.com/browserify-aes/-/browserify-aes-1.2.0.tgz
	https://registry.yarnpkg.com/browserify-cipher/-/browserify-cipher-1.0.1.tgz
	https://registry.yarnpkg.com/browserify-des/-/browserify-des-1.0.1.tgz
	https://registry.yarnpkg.com/browserify-rsa/-/browserify-rsa-4.0.1.tgz
	https://registry.yarnpkg.com/browserify-sign/-/browserify-sign-4.0.4.tgz
	https://registry.yarnpkg.com/browserify-zlib/-/browserify-zlib-0.2.0.tgz
	https://registry.yarnpkg.com/browserslist/-/browserslist-4.12.2.tgz
	https://registry.yarnpkg.com/browserslist/-/browserslist-4.16.0.tgz
	https://registry.yarnpkg.com/browserslist/-/browserslist-4.14.5.tgz
	https://registry.yarnpkg.com/buffer-from/-/buffer-from-1.1.0.tgz
	https://registry.yarnpkg.com/buffer-indexof/-/buffer-indexof-1.1.1.tgz
	https://registry.yarnpkg.com/buffer-xor/-/buffer-xor-1.0.3.tgz
	https://registry.yarnpkg.com/buffer/-/buffer-4.9.1.tgz
	https://registry.yarnpkg.com/builtin-status-codes/-/builtin-status-codes-3.0.0.tgz
	https://registry.yarnpkg.com/bytes/-/bytes-3.0.0.tgz
	https://registry.yarnpkg.com/bytes/-/bytes-3.1.0.tgz
	https://registry.yarnpkg.com/cacache/-/cacache-12.0.3.tgz
	https://registry.yarnpkg.com/cacache/-/cacache-15.0.4.tgz
	https://registry.yarnpkg.com/cache-base/-/cache-base-1.0.1.tgz
	https://registry.yarnpkg.com/call-bind/-/call-bind-1.0.2.tgz
	https://registry.yarnpkg.com/callsites/-/callsites-3.1.0.tgz
	https://registry.yarnpkg.com/camelcase-css/-/camelcase-css-2.0.1.tgz
	https://registry.yarnpkg.com/camelcase/-/camelcase-5.3.1.tgz
	https://registry.yarnpkg.com/camelize/-/camelize-1.0.0.tgz
	https://registry.yarnpkg.com/chalk/-/chalk-2.4.2.tgz
	https://registry.yarnpkg.com/chalk/-/chalk-4.1.0.tgz
	https://registry.yarnpkg.com/chart.js/-/chart.js-2.8.0.tgz
	https://registry.yarnpkg.com/chartjs-color-string/-/chartjs-color-string-0.6.0.tgz
	https://registry.yarnpkg.com/chartjs-color/-/chartjs-color-2.3.0.tgz
	https://registry.yarnpkg.com/check-types/-/check-types-8.0.3.tgz
	https://registry.yarnpkg.com/chokidar/-/chokidar-2.1.8.tgz
	https://registry.yarnpkg.com/chokidar/-/chokidar-3.4.0.tgz
	https://registry.yarnpkg.com/chokidar/-/chokidar-3.5.1.tgz
	https://registry.yarnpkg.com/chownr/-/chownr-1.1.1.tgz
	https://registry.yarnpkg.com/chownr/-/chownr-2.0.0.tgz
	https://registry.yarnpkg.com/chrome-trace-event/-/chrome-trace-event-1.0.2.tgz
	https://registry.yarnpkg.com/cipher-base/-/cipher-base-1.0.4.tgz
	https://registry.yarnpkg.com/class-utils/-/class-utils-0.3.6.tgz
	https://registry.yarnpkg.com/clean-set/-/clean-set-1.1.2.tgz
	https://registry.yarnpkg.com/clean-stack/-/clean-stack-2.2.0.tgz
	https://registry.yarnpkg.com/cliui/-/cliui-5.0.0.tgz
	https://registry.yarnpkg.com/code-point-at/-/code-point-at-1.1.0.tgz
	https://registry.yarnpkg.com/codemirror/-/codemirror-5.57.0.tgz
	https://registry.yarnpkg.com/collection-visit/-/collection-visit-1.0.0.tgz
	https://registry.yarnpkg.com/color-convert/-/color-convert-0.5.3.tgz
	https://registry.yarnpkg.com/color-convert/-/color-convert-1.9.2.tgz
	https://registry.yarnpkg.com/color-convert/-/color-convert-2.0.1.tgz
	https://registry.yarnpkg.com/color-name/-/color-name-1.1.1.tgz
	https://registry.yarnpkg.com/color-name/-/color-name-1.1.3.tgz
	https://registry.yarnpkg.com/color-name/-/color-name-1.1.4.tgz
	https://registry.yarnpkg.com/color-string/-/color-string-1.5.4.tgz
	https://registry.yarnpkg.com/color/-/color-3.1.3.tgz
	https://registry.yarnpkg.com/colorette/-/colorette-1.2.1.tgz
	https://registry.yarnpkg.com/commander/-/commander-2.20.3.tgz
	https://registry.yarnpkg.com/commander/-/commander-6.2.1.tgz
	https://registry.yarnpkg.com/commondir/-/commondir-1.0.1.tgz
	https://registry.yarnpkg.com/component-emitter/-/component-emitter-1.2.1.tgz
	https://registry.yarnpkg.com/compressible/-/compressible-2.0.17.tgz
	https://registry.yarnpkg.com/compression/-/compression-1.7.4.tgz
	https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz
	https://registry.yarnpkg.com/concat-stream/-/concat-stream-1.6.2.tgz
	https://registry.yarnpkg.com/connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz
	https://registry.yarnpkg.com/console-browserify/-/console-browserify-1.1.0.tgz
	https://registry.yarnpkg.com/console-control-strings/-/console-control-strings-1.1.0.tgz
	https://registry.yarnpkg.com/constants-browserify/-/constants-browserify-1.0.0.tgz
	https://registry.yarnpkg.com/content-disposition/-/content-disposition-0.5.3.tgz
	https://registry.yarnpkg.com/content-type/-/content-type-1.0.4.tgz
	https://registry.yarnpkg.com/convert-source-map/-/convert-source-map-1.7.0.tgz
	https://registry.yarnpkg.com/cookie-signature/-/cookie-signature-1.0.6.tgz
	https://registry.yarnpkg.com/cookie/-/cookie-0.4.0.tgz
	https://registry.yarnpkg.com/copy-concurrently/-/copy-concurrently-1.0.5.tgz
	https://registry.yarnpkg.com/copy-descriptor/-/copy-descriptor-0.1.1.tgz
	https://registry.yarnpkg.com/copy-to-clipboard/-/copy-to-clipboard-3.3.1.tgz
	https://registry.yarnpkg.com/core-js-compat/-/core-js-compat-3.6.5.tgz
	https://registry.yarnpkg.com/core-js/-/core-js-2.6.11.tgz
	https://registry.yarnpkg.com/core-util-is/-/core-util-is-1.0.2.tgz
	https://registry.yarnpkg.com/cosmiconfig/-/cosmiconfig-6.0.0.tgz
	https://registry.yarnpkg.com/create-ecdh/-/create-ecdh-4.0.3.tgz
	https://registry.yarnpkg.com/create-hash/-/create-hash-1.2.0.tgz
	https://registry.yarnpkg.com/create-hmac/-/create-hmac-1.1.7.tgz
	https://registry.yarnpkg.com/cross-env/-/cross-env-7.0.2.tgz
	https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz
	https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.1.tgz
	https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-7.0.3.tgz
	https://registry.yarnpkg.com/crypto-browserify/-/crypto-browserify-3.12.0.tgz
	https://registry.yarnpkg.com/css-color-keywords/-/css-color-keywords-1.0.0.tgz
	https://registry.yarnpkg.com/css-loader/-/css-loader-3.2.1.tgz
	https://registry.yarnpkg.com/css-to-react-native/-/css-to-react-native-3.0.0.tgz
	https://registry.yarnpkg.com/css-unit-converter/-/css-unit-converter-1.1.1.tgz
	https://registry.yarnpkg.com/cssesc/-/cssesc-3.0.0.tgz
	https://registry.yarnpkg.com/csstype/-/csstype-2.6.7.tgz
	https://registry.yarnpkg.com/csstype/-/csstype-3.0.5.tgz
	https://registry.yarnpkg.com/cyclist/-/cyclist-0.2.2.tgz
	https://registry.yarnpkg.com/data-urls/-/data-urls-2.0.0.tgz
	https://registry.yarnpkg.com/date-fns/-/date-fns-2.16.1.tgz
	https://registry.yarnpkg.com/date-now/-/date-now-0.1.4.tgz
	https://registry.yarnpkg.com/debounce/-/debounce-1.2.0.tgz
	https://registry.yarnpkg.com/debug/-/debug-2.6.9.tgz
	https://registry.yarnpkg.com/debug/-/debug-3.1.0.tgz
	https://registry.yarnpkg.com/debug/-/debug-3.2.6.tgz
	https://registry.yarnpkg.com/debug/-/debug-3.2.7.tgz
	https://registry.yarnpkg.com/debug/-/debug-4.1.1.tgz
	https://registry.yarnpkg.com/decamelize/-/decamelize-1.2.0.tgz
	https://registry.yarnpkg.com/decode-uri-component/-/decode-uri-component-0.2.0.tgz
	https://registry.yarnpkg.com/deep-equal/-/deep-equal-1.0.1.tgz
	https://registry.yarnpkg.com/deep-extend/-/deep-extend-0.6.0.tgz
	https://registry.yarnpkg.com/deep-is/-/deep-is-0.1.3.tgz
	https://registry.yarnpkg.com/deepmerge/-/deepmerge-2.2.1.tgz
	https://registry.yarnpkg.com/deepmerge/-/deepmerge-4.2.2.tgz
	https://registry.yarnpkg.com/default-gateway/-/default-gateway-4.2.0.tgz
	https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.2.tgz
	https://registry.yarnpkg.com/define-properties/-/define-properties-1.1.3.tgz
	https://registry.yarnpkg.com/define-property/-/define-property-0.2.5.tgz
	https://registry.yarnpkg.com/define-property/-/define-property-1.0.0.tgz
	https://registry.yarnpkg.com/define-property/-/define-property-2.0.2.tgz
	https://registry.yarnpkg.com/defined/-/defined-1.0.0.tgz
	https://registry.yarnpkg.com/del/-/del-4.1.1.tgz
	https://registry.yarnpkg.com/delegates/-/delegates-1.0.0.tgz
	https://registry.yarnpkg.com/depd/-/depd-1.1.2.tgz
	https://registry.yarnpkg.com/des.js/-/des.js-1.0.0.tgz
	https://registry.yarnpkg.com/destroy/-/destroy-1.0.4.tgz
	https://registry.yarnpkg.com/detect-file/-/detect-file-1.0.0.tgz
	https://registry.yarnpkg.com/detect-libc/-/detect-libc-1.0.3.tgz
	https://registry.yarnpkg.com/detect-node/-/detect-node-2.0.4.tgz
	https://registry.yarnpkg.com/detective/-/detective-5.2.0.tgz
	https://registry.yarnpkg.com/didyoumean/-/didyoumean-1.2.1.tgz
	https://registry.yarnpkg.com/diffie-hellman/-/diffie-hellman-5.0.3.tgz
	https://registry.yarnpkg.com/dir-glob/-/dir-glob-3.0.1.tgz
	https://registry.yarnpkg.com/dns-equal/-/dns-equal-1.0.0.tgz
	https://registry.yarnpkg.com/dns-packet/-/dns-packet-1.3.1.tgz
	https://registry.yarnpkg.com/dns-txt/-/dns-txt-2.0.2.tgz
	https://registry.yarnpkg.com/doctrine/-/doctrine-2.1.0.tgz
	https://registry.yarnpkg.com/doctrine/-/doctrine-3.0.0.tgz
	https://registry.yarnpkg.com/dom-helpers/-/dom-helpers-5.1.3.tgz
	https://registry.yarnpkg.com/dom-walk/-/dom-walk-0.1.1.tgz
	https://registry.yarnpkg.com/domain-browser/-/domain-browser-1.2.0.tgz
	https://registry.yarnpkg.com/dset/-/dset-2.0.1.tgz
	https://registry.yarnpkg.com/duplexer/-/duplexer-0.1.1.tgz
	https://registry.yarnpkg.com/duplexify/-/duplexify-3.6.0.tgz
	https://registry.yarnpkg.com/easy-peasy/-/easy-peasy-4.0.1.tgz
	https://registry.yarnpkg.com/ee-first/-/ee-first-1.1.1.tgz
	https://registry.yarnpkg.com/ejs/-/ejs-2.7.4.tgz
	https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.487.tgz
	https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.582.tgz
	https://registry.yarnpkg.com/electron-to-chromium/-/electron-to-chromium-1.3.633.tgz
	https://registry.yarnpkg.com/elliptic/-/elliptic-6.4.0.tgz
	https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-7.0.3.tgz
	https://registry.yarnpkg.com/emoji-regex/-/emoji-regex-8.0.0.tgz
	https://registry.yarnpkg.com/emojis-list/-/emojis-list-2.1.0.tgz
	https://registry.yarnpkg.com/emojis-list/-/emojis-list-3.0.0.tgz
	https://registry.yarnpkg.com/encodeurl/-/encodeurl-1.0.2.tgz
	https://registry.yarnpkg.com/end-of-stream/-/end-of-stream-1.4.1.tgz
	https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.1.0.tgz
	https://registry.yarnpkg.com/enhanced-resolve/-/enhanced-resolve-4.2.0.tgz
	https://registry.yarnpkg.com/enquirer/-/enquirer-2.3.6.tgz
	https://registry.yarnpkg.com/errno/-/errno-0.1.7.tgz
	https://registry.yarnpkg.com/error-ex/-/error-ex-1.3.2.tgz
	https://registry.yarnpkg.com/es-abstract/-/es-abstract-1.18.3.tgz
	https://registry.yarnpkg.com/es-to-primitive/-/es-to-primitive-1.2.1.tgz
	https://registry.yarnpkg.com/escalade/-/escalade-3.0.1.tgz
	https://registry.yarnpkg.com/escalade/-/escalade-3.1.1.tgz
	https://registry.yarnpkg.com/escape-html/-/escape-html-1.0.3.tgz
	https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz
	https://registry.yarnpkg.com/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz
	https://registry.yarnpkg.com/eslint-config-standard/-/eslint-config-standard-16.0.3.tgz
	https://registry.yarnpkg.com/eslint-import-resolver-node/-/eslint-import-resolver-node-0.3.4.tgz
	https://registry.yarnpkg.com/eslint-module-utils/-/eslint-module-utils-2.6.1.tgz
	https://registry.yarnpkg.com/eslint-plugin-es/-/eslint-plugin-es-3.0.1.tgz
	https://registry.yarnpkg.com/eslint-plugin-import/-/eslint-plugin-import-2.23.3.tgz
	https://registry.yarnpkg.com/eslint-plugin-node/-/eslint-plugin-node-11.1.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-promise/-/eslint-plugin-promise-5.1.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-react-hooks/-/eslint-plugin-react-hooks-4.2.0.tgz
	https://registry.yarnpkg.com/eslint-plugin-react/-/eslint-plugin-react-7.23.2.tgz
	https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-4.0.3.tgz
	https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.0.0.tgz
	https://registry.yarnpkg.com/eslint-scope/-/eslint-scope-5.1.1.tgz
	https://registry.yarnpkg.com/eslint-utils/-/eslint-utils-2.1.0.tgz
	https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.1.0.tgz
	https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-1.3.0.tgz
	https://registry.yarnpkg.com/eslint-visitor-keys/-/eslint-visitor-keys-2.1.0.tgz
	https://registry.yarnpkg.com/eslint/-/eslint-7.27.0.tgz
	https://registry.yarnpkg.com/espree/-/espree-7.3.1.tgz
	https://registry.yarnpkg.com/esprima/-/esprima-4.0.0.tgz
	https://registry.yarnpkg.com/esquery/-/esquery-1.4.0.tgz
	https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.2.1.tgz
	https://registry.yarnpkg.com/esrecurse/-/esrecurse-4.3.0.tgz
	https://registry.yarnpkg.com/estraverse/-/estraverse-4.2.0.tgz
	https://registry.yarnpkg.com/estraverse/-/estraverse-5.1.0.tgz
	https://registry.yarnpkg.com/estraverse/-/estraverse-5.2.0.tgz
	https://registry.yarnpkg.com/esutils/-/esutils-2.0.2.tgz
	https://registry.yarnpkg.com/etag/-/etag-1.8.1.tgz
	https://registry.yarnpkg.com/eventemitter3/-/eventemitter3-4.0.0.tgz
	https://registry.yarnpkg.com/events/-/events-3.0.0.tgz
	https://registry.yarnpkg.com/eventsource/-/eventsource-1.0.7.tgz
	https://registry.yarnpkg.com/evp_bytestokey/-/evp_bytestokey-1.0.3.tgz
	https://registry.yarnpkg.com/execa/-/execa-1.0.0.tgz
	https://registry.yarnpkg.com/expand-brackets/-/expand-brackets-2.1.4.tgz
	https://registry.yarnpkg.com/expand-tilde/-/expand-tilde-2.0.2.tgz
	https://registry.yarnpkg.com/express/-/express-4.17.1.tgz
	https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-2.0.1.tgz
	https://registry.yarnpkg.com/extend-shallow/-/extend-shallow-3.0.2.tgz
	https://registry.yarnpkg.com/extglob/-/extglob-2.0.4.tgz
	https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-2.0.1.tgz
	https://registry.yarnpkg.com/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz
	https://registry.yarnpkg.com/fast-glob/-/fast-glob-3.2.5.tgz
	https://registry.yarnpkg.com/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz
	https://registry.yarnpkg.com/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz
	https://registry.yarnpkg.com/fastq/-/fastq-1.11.0.tgz
	https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.10.0.tgz
	https://registry.yarnpkg.com/faye-websocket/-/faye-websocket-0.11.1.tgz
	https://registry.yarnpkg.com/figgy-pudding/-/figgy-pudding-3.5.1.tgz
	https://registry.yarnpkg.com/file-entry-cache/-/file-entry-cache-6.0.1.tgz
	https://registry.yarnpkg.com/file-loader/-/file-loader-6.0.0.tgz
	https://registry.yarnpkg.com/filesize/-/filesize-3.6.1.tgz
	https://registry.yarnpkg.com/fill-range/-/fill-range-4.0.0.tgz
	https://registry.yarnpkg.com/fill-range/-/fill-range-7.0.1.tgz
	https://registry.yarnpkg.com/finalhandler/-/finalhandler-1.1.2.tgz
	https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-2.1.0.tgz
	https://registry.yarnpkg.com/find-cache-dir/-/find-cache-dir-3.3.1.tgz
	https://registry.yarnpkg.com/find-up/-/find-up-2.1.0.tgz
	https://registry.yarnpkg.com/find-up/-/find-up-3.0.0.tgz
	https://registry.yarnpkg.com/find-up/-/find-up-4.1.0.tgz
	https://registry.yarnpkg.com/findup-sync/-/findup-sync-3.0.0.tgz
	https://registry.yarnpkg.com/flat-cache/-/flat-cache-3.0.4.tgz
	https://registry.yarnpkg.com/flatted/-/flatted-3.1.1.tgz
	https://registry.yarnpkg.com/flush-write-stream/-/flush-write-stream-1.0.3.tgz
	https://registry.yarnpkg.com/fn-name/-/fn-name-3.0.0.tgz
	https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.6.1.tgz
	https://registry.yarnpkg.com/follow-redirects/-/follow-redirects-1.13.1.tgz
	https://registry.yarnpkg.com/for-in/-/for-in-1.0.2.tgz
	https://registry.yarnpkg.com/foreach/-/foreach-2.0.5.tgz
	https://registry.yarnpkg.com/fork-ts-checker-webpack-plugin/-/fork-ts-checker-webpack-plugin-6.2.10.tgz
	https://registry.yarnpkg.com/formik/-/formik-2.2.6.tgz
	https://registry.yarnpkg.com/forwarded/-/forwarded-0.1.2.tgz
	https://registry.yarnpkg.com/fraction.js/-/fraction.js-4.0.13.tgz
	https://registry.yarnpkg.com/fragment-cache/-/fragment-cache-0.2.1.tgz
	https://registry.yarnpkg.com/fresh/-/fresh-0.5.2.tgz
	https://registry.yarnpkg.com/from2/-/from2-2.3.0.tgz
	https://registry.yarnpkg.com/fs-extra/-/fs-extra-9.0.1.tgz
	https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-1.2.5.tgz
	https://registry.yarnpkg.com/fs-minipass/-/fs-minipass-2.1.0.tgz
	https://registry.yarnpkg.com/fs-monkey/-/fs-monkey-1.0.1.tgz
	https://registry.yarnpkg.com/fs-write-stream-atomic/-/fs-write-stream-atomic-1.0.10.tgz
	https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz
	https://registry.yarnpkg.com/fsevents/-/fsevents-1.2.7.tgz
	https://registry.yarnpkg.com/fsevents/-/fsevents-2.1.3.tgz
	https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.2.tgz
	https://registry.yarnpkg.com/function-bind/-/function-bind-1.1.1.tgz
	https://registry.yarnpkg.com/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz
	https://registry.yarnpkg.com/gauge/-/gauge-2.7.4.tgz
	https://registry.yarnpkg.com/gensync/-/gensync-1.0.0-beta.1.tgz
	https://registry.yarnpkg.com/get-caller-file/-/get-caller-file-2.0.5.tgz
	https://registry.yarnpkg.com/get-intrinsic/-/get-intrinsic-1.1.1.tgz
	https://registry.yarnpkg.com/get-stream/-/get-stream-4.1.0.tgz
	https://registry.yarnpkg.com/get-value/-/get-value-2.0.6.tgz
	https://registry.yarnpkg.com/glob-parent/-/glob-parent-3.1.0.tgz
	https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.1.tgz
	https://registry.yarnpkg.com/glob-parent/-/glob-parent-5.1.2.tgz
	https://registry.yarnpkg.com/glob/-/glob-7.1.6.tgz
	https://registry.yarnpkg.com/glob/-/glob-7.1.4.tgz
	https://registry.yarnpkg.com/glob/-/glob-7.1.7.tgz
	https://registry.yarnpkg.com/global-modules/-/global-modules-1.0.0.tgz
	https://registry.yarnpkg.com/global-modules/-/global-modules-2.0.0.tgz
	https://registry.yarnpkg.com/global-prefix/-/global-prefix-1.0.2.tgz
	https://registry.yarnpkg.com/global-prefix/-/global-prefix-3.0.0.tgz
	https://registry.yarnpkg.com/global/-/global-4.3.2.tgz
	https://registry.yarnpkg.com/globals/-/globals-11.12.0.tgz
	https://registry.yarnpkg.com/globals/-/globals-12.4.0.tgz
	https://registry.yarnpkg.com/globals/-/globals-13.9.0.tgz
	https://registry.yarnpkg.com/globby/-/globby-11.0.3.tgz
	https://registry.yarnpkg.com/globby/-/globby-6.1.0.tgz
	https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.1.15.tgz
	https://registry.yarnpkg.com/graceful-fs/-/graceful-fs-4.2.4.tgz
	https://registry.yarnpkg.com/gud/-/gud-1.0.0.tgz
	https://registry.yarnpkg.com/gzip-size/-/gzip-size-5.1.1.tgz
	https://registry.yarnpkg.com/handle-thing/-/handle-thing-2.0.0.tgz
	https://registry.yarnpkg.com/has-bigints/-/has-bigints-1.0.1.tgz
	https://registry.yarnpkg.com/has-flag/-/has-flag-3.0.0.tgz
	https://registry.yarnpkg.com/has-flag/-/has-flag-4.0.0.tgz
	https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.0.tgz
	https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.1.tgz
	https://registry.yarnpkg.com/has-symbols/-/has-symbols-1.0.2.tgz
	https://registry.yarnpkg.com/has-unicode/-/has-unicode-2.0.1.tgz
	https://registry.yarnpkg.com/has-value/-/has-value-0.3.1.tgz
	https://registry.yarnpkg.com/has-value/-/has-value-1.0.0.tgz
	https://registry.yarnpkg.com/has-values/-/has-values-0.1.4.tgz
	https://registry.yarnpkg.com/has-values/-/has-values-1.0.0.tgz
	https://registry.yarnpkg.com/has/-/has-1.0.3.tgz
	https://registry.yarnpkg.com/hash-base/-/hash-base-3.0.4.tgz
	https://registry.yarnpkg.com/hash.js/-/hash.js-1.1.3.tgz
	https://registry.yarnpkg.com/history/-/history-4.9.0.tgz
	https://registry.yarnpkg.com/hmac-drbg/-/hmac-drbg-1.0.1.tgz
	https://registry.yarnpkg.com/hoist-non-react-statics/-/hoist-non-react-statics-3.3.2.tgz
	https://registry.yarnpkg.com/hoist-non-react-statics/-/hoist-non-react-statics-3.3.0.tgz
	https://registry.yarnpkg.com/homedir-polyfill/-/homedir-polyfill-1.0.3.tgz
	https://registry.yarnpkg.com/hoopy/-/hoopy-0.1.4.tgz
	https://registry.yarnpkg.com/hosted-git-info/-/hosted-git-info-2.8.8.tgz
	https://registry.yarnpkg.com/hpack.js/-/hpack.js-2.1.6.tgz
	https://registry.yarnpkg.com/html-entities/-/html-entities-1.3.1.tgz
	https://registry.yarnpkg.com/html-parse-stringify2/-/html-parse-stringify2-2.0.1.tgz
	https://registry.yarnpkg.com/html-tags/-/html-tags-3.1.0.tgz
	https://registry.yarnpkg.com/http-deceiver/-/http-deceiver-1.2.7.tgz
	https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.2.tgz
	https://registry.yarnpkg.com/http-errors/-/http-errors-1.6.3.tgz
	https://registry.yarnpkg.com/http-errors/-/http-errors-1.7.3.tgz
	https://registry.yarnpkg.com/http-parser-js/-/http-parser-js-0.5.0.tgz
	https://registry.yarnpkg.com/http-proxy-middleware/-/http-proxy-middleware-0.19.1.tgz
	https://registry.yarnpkg.com/http-proxy/-/http-proxy-1.18.0.tgz
	https://registry.yarnpkg.com/https-browserify/-/https-browserify-1.0.0.tgz
	https://registry.yarnpkg.com/i18next-chained-backend/-/i18next-chained-backend-2.0.0.tgz
	https://registry.yarnpkg.com/i18next-localstorage-backend/-/i18next-localstorage-backend-3.0.0.tgz
	https://registry.yarnpkg.com/i18next-xhr-backend/-/i18next-xhr-backend-3.2.2.tgz
	https://registry.yarnpkg.com/i18next/-/i18next-19.0.0.tgz
	https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.4.24.tgz
	https://registry.yarnpkg.com/iconv-lite/-/iconv-lite-0.5.2.tgz
	https://registry.yarnpkg.com/icss-utils/-/icss-utils-4.1.1.tgz
	https://registry.yarnpkg.com/ieee754/-/ieee754-1.1.11.tgz
	https://registry.yarnpkg.com/iferr/-/iferr-0.1.5.tgz
	https://registry.yarnpkg.com/ignore-walk/-/ignore-walk-3.0.1.tgz
	https://registry.yarnpkg.com/ignore/-/ignore-4.0.6.tgz
	https://registry.yarnpkg.com/ignore/-/ignore-5.1.2.tgz
	https://registry.yarnpkg.com/ignore/-/ignore-5.1.8.tgz
	https://registry.yarnpkg.com/immer/-/immer-7.0.9.tgz
	https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.0.0.tgz
	https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.2.1.tgz
	https://registry.yarnpkg.com/import-fresh/-/import-fresh-3.3.0.tgz
	https://registry.yarnpkg.com/import-local/-/import-local-2.0.0.tgz
	https://registry.yarnpkg.com/imurmurhash/-/imurmurhash-0.1.4.tgz
	https://registry.yarnpkg.com/indent-string/-/indent-string-4.0.0.tgz
	https://registry.yarnpkg.com/indexes-of/-/indexes-of-1.0.1.tgz
	https://registry.yarnpkg.com/infer-owner/-/infer-owner-1.0.4.tgz
	https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz
	https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz
	https://registry.yarnpkg.com/inherits/-/inherits-2.0.1.tgz
	https://registry.yarnpkg.com/inherits/-/inherits-2.0.3.tgz
	https://registry.yarnpkg.com/ini/-/ini-1.3.5.tgz
	https://registry.yarnpkg.com/internal-ip/-/internal-ip-4.3.0.tgz
	https://registry.yarnpkg.com/internal-slot/-/internal-slot-1.0.3.tgz
	https://registry.yarnpkg.com/interpret/-/interpret-1.4.0.tgz
	https://registry.yarnpkg.com/ip-regex/-/ip-regex-2.1.0.tgz
	https://registry.yarnpkg.com/ip/-/ip-1.1.5.tgz
	https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.0.tgz
	https://registry.yarnpkg.com/ipaddr.js/-/ipaddr.js-1.9.1.tgz
	https://registry.yarnpkg.com/is-absolute-url/-/is-absolute-url-3.0.3.tgz
	https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-0.1.6.tgz
	https://registry.yarnpkg.com/is-accessor-descriptor/-/is-accessor-descriptor-1.0.0.tgz
	https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.2.1.tgz
	https://registry.yarnpkg.com/is-arrayish/-/is-arrayish-0.3.1.tgz
	https://registry.yarnpkg.com/is-bigint/-/is-bigint-1.0.2.tgz
	https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-1.0.1.tgz
	https://registry.yarnpkg.com/is-binary-path/-/is-binary-path-2.1.0.tgz
	https://registry.yarnpkg.com/is-boolean-object/-/is-boolean-object-1.1.1.tgz
	https://registry.yarnpkg.com/is-buffer/-/is-buffer-1.1.6.tgz
	https://registry.yarnpkg.com/is-callable/-/is-callable-1.1.4.tgz
	https://registry.yarnpkg.com/is-callable/-/is-callable-1.2.3.tgz
	https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.2.0.tgz
	https://registry.yarnpkg.com/is-core-module/-/is-core-module-2.4.0.tgz
	https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-0.1.4.tgz
	https://registry.yarnpkg.com/is-data-descriptor/-/is-data-descriptor-1.0.0.tgz
	https://registry.yarnpkg.com/is-date-object/-/is-date-object-1.0.1.tgz
	https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-0.1.6.tgz
	https://registry.yarnpkg.com/is-descriptor/-/is-descriptor-1.0.2.tgz
	https://registry.yarnpkg.com/is-extendable/-/is-extendable-0.1.1.tgz
	https://registry.yarnpkg.com/is-extendable/-/is-extendable-1.0.1.tgz
	https://registry.yarnpkg.com/is-extglob/-/is-extglob-2.1.1.tgz
	https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz
	https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-2.0.0.tgz
	https://registry.yarnpkg.com/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz
	https://registry.yarnpkg.com/is-glob/-/is-glob-3.1.0.tgz
	https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.0.tgz
	https://registry.yarnpkg.com/is-glob/-/is-glob-4.0.1.tgz
	https://registry.yarnpkg.com/is-negative-zero/-/is-negative-zero-2.0.1.tgz
	https://registry.yarnpkg.com/is-number-object/-/is-number-object-1.0.5.tgz
	https://registry.yarnpkg.com/is-number/-/is-number-3.0.0.tgz
	https://registry.yarnpkg.com/is-number/-/is-number-4.0.0.tgz
	https://registry.yarnpkg.com/is-number/-/is-number-7.0.0.tgz
	https://registry.yarnpkg.com/is-odd/-/is-odd-2.0.0.tgz
	https://registry.yarnpkg.com/is-path-cwd/-/is-path-cwd-2.2.0.tgz
	https://registry.yarnpkg.com/is-path-in-cwd/-/is-path-in-cwd-2.1.0.tgz
	https://registry.yarnpkg.com/is-path-inside/-/is-path-inside-2.1.0.tgz
	https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-2.0.4.tgz
	https://registry.yarnpkg.com/is-plain-object/-/is-plain-object-5.0.0.tgz
	https://registry.yarnpkg.com/is-regex/-/is-regex-1.1.3.tgz
	https://registry.yarnpkg.com/is-stream/-/is-stream-1.1.0.tgz
	https://registry.yarnpkg.com/is-string/-/is-string-1.0.5.tgz
	https://registry.yarnpkg.com/is-string/-/is-string-1.0.6.tgz
	https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.2.tgz
	https://registry.yarnpkg.com/is-symbol/-/is-symbol-1.0.4.tgz
	https://registry.yarnpkg.com/is-windows/-/is-windows-1.0.2.tgz
	https://registry.yarnpkg.com/is-wsl/-/is-wsl-1.1.0.tgz
	https://registry.yarnpkg.com/isarray/-/isarray-0.0.1.tgz
	https://registry.yarnpkg.com/isarray/-/isarray-1.0.0.tgz
	https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz
	https://registry.yarnpkg.com/isobject/-/isobject-2.1.0.tgz
	https://registry.yarnpkg.com/isobject/-/isobject-3.0.1.tgz
	https://registry.yarnpkg.com/jest-worker/-/jest-worker-26.1.0.tgz
	https://registry.yarnpkg.com/js-tokens/-/js-tokens-4.0.0.tgz
	https://registry.yarnpkg.com/js-yaml/-/js-yaml-3.13.1.tgz
	https://registry.yarnpkg.com/jsesc/-/jsesc-2.5.1.tgz
	https://registry.yarnpkg.com/jsesc/-/jsesc-0.5.0.tgz
	https://registry.yarnpkg.com/json-parse-better-errors/-/json-parse-better-errors-1.0.2.tgz
	https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz
	https://registry.yarnpkg.com/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz
	https://registry.yarnpkg.com/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz
	https://registry.yarnpkg.com/json3/-/json3-3.3.2.tgz
	https://registry.yarnpkg.com/json5/-/json5-1.0.1.tgz
	https://registry.yarnpkg.com/json5/-/json5-2.1.3.tgz
	https://registry.yarnpkg.com/jsonfile/-/jsonfile-6.0.1.tgz
	https://registry.yarnpkg.com/jsx-ast-utils/-/jsx-ast-utils-3.2.0.tgz
	https://registry.yarnpkg.com/killable/-/killable-1.0.1.tgz
	https://registry.yarnpkg.com/kind-of/-/kind-of-3.2.2.tgz
	https://registry.yarnpkg.com/kind-of/-/kind-of-4.0.0.tgz
	https://registry.yarnpkg.com/kind-of/-/kind-of-5.1.0.tgz
	https://registry.yarnpkg.com/kind-of/-/kind-of-6.0.2.tgz
	https://registry.yarnpkg.com/levn/-/levn-0.4.1.tgz
	https://registry.yarnpkg.com/lines-and-columns/-/lines-and-columns-1.1.6.tgz
	https://registry.yarnpkg.com/load-json-file/-/load-json-file-4.0.0.tgz
	https://registry.yarnpkg.com/loader-runner/-/loader-runner-2.4.0.tgz
	https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.2.3.tgz
	https://registry.yarnpkg.com/loader-utils/-/loader-utils-1.4.0.tgz
	https://registry.yarnpkg.com/loader-utils/-/loader-utils-2.0.0.tgz
	https://registry.yarnpkg.com/locate-path/-/locate-path-2.0.0.tgz
	https://registry.yarnpkg.com/locate-path/-/locate-path-3.0.0.tgz
	https://registry.yarnpkg.com/locate-path/-/locate-path-5.0.0.tgz
	https://registry.yarnpkg.com/lodash-es/-/lodash-es-4.17.15.tgz
	https://registry.yarnpkg.com/lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz
	https://registry.yarnpkg.com/lodash.get/-/lodash.get-4.4.2.tgz
	https://registry.yarnpkg.com/lodash.has/-/lodash.has-4.5.2.tgz
	https://registry.yarnpkg.com/lodash.merge/-/lodash.merge-4.6.2.tgz
	https://registry.yarnpkg.com/lodash.sortby/-/lodash.sortby-4.7.0.tgz
	https://registry.yarnpkg.com/lodash.toarray/-/lodash.toarray-4.4.0.tgz
	https://registry.yarnpkg.com/lodash.truncate/-/lodash.truncate-4.4.2.tgz
	https://registry.yarnpkg.com/lodash/-/lodash-4.17.15.tgz
	https://registry.yarnpkg.com/lodash/-/lodash-4.17.20.tgz
	https://registry.yarnpkg.com/loglevel/-/loglevel-1.6.8.tgz
	https://registry.yarnpkg.com/loose-envify/-/loose-envify-1.4.0.tgz
	https://registry.yarnpkg.com/lru-cache/-/lru-cache-5.1.1.tgz
	https://registry.yarnpkg.com/make-dir/-/make-dir-2.1.0.tgz
	https://registry.yarnpkg.com/make-dir/-/make-dir-3.1.0.tgz
	https://registry.yarnpkg.com/map-cache/-/map-cache-0.2.2.tgz
	https://registry.yarnpkg.com/map-or-similar/-/map-or-similar-1.5.0.tgz
	https://registry.yarnpkg.com/map-visit/-/map-visit-1.0.0.tgz
	https://registry.yarnpkg.com/md5.js/-/md5.js-1.3.4.tgz
	https://registry.yarnpkg.com/media-typer/-/media-typer-0.3.0.tgz
	https://registry.yarnpkg.com/memfs/-/memfs-3.2.0.tgz
	https://registry.yarnpkg.com/memoizerific/-/memoizerific-1.11.3.tgz
	https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.4.1.tgz
	https://registry.yarnpkg.com/memory-fs/-/memory-fs-0.5.0.tgz
	https://registry.yarnpkg.com/merge-descriptors/-/merge-descriptors-1.0.1.tgz
	https://registry.yarnpkg.com/merge-stream/-/merge-stream-2.0.0.tgz
	https://registry.yarnpkg.com/merge2/-/merge2-1.4.1.tgz
	https://registry.yarnpkg.com/methods/-/methods-1.1.2.tgz
	https://registry.yarnpkg.com/micromatch/-/micromatch-3.1.10.tgz
	https://registry.yarnpkg.com/micromatch/-/micromatch-4.0.4.tgz
	https://registry.yarnpkg.com/miller-rabin/-/miller-rabin-4.0.1.tgz
	https://registry.yarnpkg.com/mime-db/-/mime-db-1.40.0.tgz
	https://registry.yarnpkg.com/mime-db/-/mime-db-1.41.0.tgz
	https://registry.yarnpkg.com/mime-types/-/mime-types-2.1.24.tgz
	https://registry.yarnpkg.com/mime/-/mime-1.6.0.tgz
	https://registry.yarnpkg.com/mime/-/mime-2.4.4.tgz
	https://registry.yarnpkg.com/min-document/-/min-document-2.19.0.tgz
	https://registry.yarnpkg.com/mini-create-react-context/-/mini-create-react-context-0.3.2.tgz
	https://registry.yarnpkg.com/mini-svg-data-uri/-/mini-svg-data-uri-1.2.3.tgz
	https://registry.yarnpkg.com/minimalistic-assert/-/minimalistic-assert-1.0.1.tgz
	https://registry.yarnpkg.com/minimalistic-crypto-utils/-/minimalistic-crypto-utils-1.0.1.tgz
	https://registry.yarnpkg.com/minimatch/-/minimatch-3.0.4.tgz
	https://registry.yarnpkg.com/minimist/-/minimist-0.0.8.tgz
	https://registry.yarnpkg.com/minimist/-/minimist-1.2.5.tgz
	https://registry.yarnpkg.com/minimist/-/minimist-1.2.0.tgz
	https://registry.yarnpkg.com/minipass-collect/-/minipass-collect-1.0.2.tgz
	https://registry.yarnpkg.com/minipass-flush/-/minipass-flush-1.0.5.tgz
	https://registry.yarnpkg.com/minipass-pipeline/-/minipass-pipeline-1.2.3.tgz
	https://registry.yarnpkg.com/minipass/-/minipass-2.3.3.tgz
	https://registry.yarnpkg.com/minipass/-/minipass-3.1.3.tgz
	https://registry.yarnpkg.com/minizlib/-/minizlib-1.1.0.tgz
	https://registry.yarnpkg.com/minizlib/-/minizlib-2.1.0.tgz
	https://registry.yarnpkg.com/mississippi/-/mississippi-3.0.0.tgz
	https://registry.yarnpkg.com/mixin-deep/-/mixin-deep-1.3.1.tgz
	https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.1.tgz
	https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.5.tgz
	https://registry.yarnpkg.com/mkdirp/-/mkdirp-1.0.4.tgz
	https://registry.yarnpkg.com/modern-normalize/-/modern-normalize-1.0.0.tgz
	https://registry.yarnpkg.com/moment/-/moment-2.24.0.tgz
	https://registry.yarnpkg.com/move-concurrently/-/move-concurrently-1.0.1.tgz
	https://registry.yarnpkg.com/ms/-/ms-2.0.0.tgz
	https://registry.yarnpkg.com/ms/-/ms-2.1.1.tgz
	https://registry.yarnpkg.com/multicast-dns-service-types/-/multicast-dns-service-types-1.1.0.tgz
	https://registry.yarnpkg.com/multicast-dns/-/multicast-dns-6.2.3.tgz
	https://registry.yarnpkg.com/nan/-/nan-2.10.0.tgz
	https://registry.yarnpkg.com/nanoid/-/nanoid-3.1.20.tgz
	https://registry.yarnpkg.com/nanomatch/-/nanomatch-1.2.9.tgz
	https://registry.yarnpkg.com/natural-compare/-/natural-compare-1.4.0.tgz
	https://registry.yarnpkg.com/needle/-/needle-2.2.1.tgz
	https://registry.yarnpkg.com/negotiator/-/negotiator-0.6.2.tgz
	https://registry.yarnpkg.com/neo-async/-/neo-async-2.6.1.tgz
	https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.4.tgz
	https://registry.yarnpkg.com/node-emoji/-/node-emoji-1.8.1.tgz
	https://registry.yarnpkg.com/node-forge/-/node-forge-0.9.0.tgz
	https://registry.yarnpkg.com/node-libs-browser/-/node-libs-browser-2.2.1.tgz
	https://registry.yarnpkg.com/node-pre-gyp/-/node-pre-gyp-0.10.0.tgz
	https://registry.yarnpkg.com/node-releases/-/node-releases-1.1.58.tgz
	https://registry.yarnpkg.com/node-releases/-/node-releases-1.1.63.tgz
	https://registry.yarnpkg.com/node-releases/-/node-releases-1.1.67.tgz
	https://registry.yarnpkg.com/nopt/-/nopt-4.0.1.tgz
	https://registry.yarnpkg.com/normalize-package-data/-/normalize-package-data-2.5.0.tgz
	https://registry.yarnpkg.com/normalize-path/-/normalize-path-2.1.1.tgz
	https://registry.yarnpkg.com/normalize-path/-/normalize-path-3.0.0.tgz
	https://registry.yarnpkg.com/normalize-range/-/normalize-range-0.1.2.tgz
	https://registry.yarnpkg.com/npm-bundled/-/npm-bundled-1.0.3.tgz
	https://registry.yarnpkg.com/npm-packlist/-/npm-packlist-1.1.10.tgz
	https://registry.yarnpkg.com/npm-run-path/-/npm-run-path-2.0.2.tgz
	https://registry.yarnpkg.com/npmlog/-/npmlog-4.1.2.tgz
	https://registry.yarnpkg.com/number-is-nan/-/number-is-nan-1.0.1.tgz
	https://registry.yarnpkg.com/object-assign/-/object-assign-4.1.1.tgz
	https://registry.yarnpkg.com/object-copy/-/object-copy-0.1.0.tgz
	https://registry.yarnpkg.com/object-hash/-/object-hash-2.0.3.tgz
	https://registry.yarnpkg.com/object-inspect/-/object-inspect-1.10.3.tgz
	https://registry.yarnpkg.com/object-keys/-/object-keys-1.1.1.tgz
	https://registry.yarnpkg.com/object-visit/-/object-visit-1.0.1.tgz
	https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.0.tgz
	https://registry.yarnpkg.com/object.assign/-/object.assign-4.1.2.tgz
	https://registry.yarnpkg.com/object.entries/-/object.entries-1.1.4.tgz
	https://registry.yarnpkg.com/object.fromentries/-/object.fromentries-2.0.4.tgz
	https://registry.yarnpkg.com/object.pick/-/object.pick-1.3.0.tgz
	https://registry.yarnpkg.com/object.values/-/object.values-1.1.4.tgz
	https://registry.yarnpkg.com/obuf/-/obuf-1.1.2.tgz
	https://registry.yarnpkg.com/on-finished/-/on-finished-2.3.0.tgz
	https://registry.yarnpkg.com/on-headers/-/on-headers-1.0.2.tgz
	https://registry.yarnpkg.com/once/-/once-1.4.0.tgz
	https://registry.yarnpkg.com/opener/-/opener-1.5.1.tgz
	https://registry.yarnpkg.com/opn/-/opn-5.5.0.tgz
	https://registry.yarnpkg.com/optionator/-/optionator-0.9.1.tgz
	https://registry.yarnpkg.com/original/-/original-1.0.2.tgz
	https://registry.yarnpkg.com/os-browserify/-/os-browserify-0.3.0.tgz
	https://registry.yarnpkg.com/os-homedir/-/os-homedir-1.0.2.tgz
	https://registry.yarnpkg.com/os-tmpdir/-/os-tmpdir-1.0.2.tgz
	https://registry.yarnpkg.com/osenv/-/osenv-0.1.5.tgz
	https://registry.yarnpkg.com/p-finally/-/p-finally-1.0.0.tgz
	https://registry.yarnpkg.com/p-limit/-/p-limit-1.3.0.tgz
	https://registry.yarnpkg.com/p-limit/-/p-limit-2.1.0.tgz
	https://registry.yarnpkg.com/p-limit/-/p-limit-2.3.0.tgz
	https://registry.yarnpkg.com/p-limit/-/p-limit-3.0.1.tgz
	https://registry.yarnpkg.com/p-locate/-/p-locate-2.0.0.tgz
	https://registry.yarnpkg.com/p-locate/-/p-locate-3.0.0.tgz
	https://registry.yarnpkg.com/p-locate/-/p-locate-4.1.0.tgz
	https://registry.yarnpkg.com/p-map/-/p-map-2.1.0.tgz
	https://registry.yarnpkg.com/p-map/-/p-map-4.0.0.tgz
	https://registry.yarnpkg.com/p-retry/-/p-retry-3.0.1.tgz
	https://registry.yarnpkg.com/p-try/-/p-try-1.0.0.tgz
	https://registry.yarnpkg.com/p-try/-/p-try-2.0.0.tgz
	https://registry.yarnpkg.com/pako/-/pako-1.0.6.tgz
	https://registry.yarnpkg.com/parallel-transform/-/parallel-transform-1.1.0.tgz
	https://registry.yarnpkg.com/parent-module/-/parent-module-1.0.1.tgz
	https://registry.yarnpkg.com/parse-asn1/-/parse-asn1-5.1.1.tgz
	https://registry.yarnpkg.com/parse-json/-/parse-json-4.0.0.tgz
	https://registry.yarnpkg.com/parse-json/-/parse-json-5.0.0.tgz
	https://registry.yarnpkg.com/parse-passwd/-/parse-passwd-1.0.0.tgz
	https://registry.yarnpkg.com/parseurl/-/parseurl-1.3.3.tgz
	https://registry.yarnpkg.com/pascalcase/-/pascalcase-0.1.1.tgz
	https://registry.yarnpkg.com/path-browserify/-/path-browserify-0.0.1.tgz
	https://registry.yarnpkg.com/path-dirname/-/path-dirname-1.0.2.tgz
	https://registry.yarnpkg.com/path-exists/-/path-exists-3.0.0.tgz
	https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz
	https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz
	https://registry.yarnpkg.com/path-is-inside/-/path-is-inside-1.0.2.tgz
	https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz
	https://registry.yarnpkg.com/path-key/-/path-key-3.1.1.tgz
	https://registry.yarnpkg.com/path-parse/-/path-parse-1.0.6.tgz
	https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-0.1.7.tgz
	https://registry.yarnpkg.com/path-to-regexp/-/path-to-regexp-1.7.0.tgz
	https://registry.yarnpkg.com/path-type/-/path-type-3.0.0.tgz
	https://registry.yarnpkg.com/path-type/-/path-type-4.0.0.tgz
	https://registry.yarnpkg.com/pbkdf2/-/pbkdf2-3.0.16.tgz
	https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.2.tgz
	https://registry.yarnpkg.com/picomatch/-/picomatch-2.2.3.tgz
	https://registry.yarnpkg.com/pify/-/pify-2.3.0.tgz
	https://registry.yarnpkg.com/pify/-/pify-3.0.0.tgz
	https://registry.yarnpkg.com/pify/-/pify-4.0.1.tgz
	https://registry.yarnpkg.com/pinkie-promise/-/pinkie-promise-2.0.1.tgz
	https://registry.yarnpkg.com/pinkie/-/pinkie-2.0.4.tgz
	https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-2.0.0.tgz
	https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-3.0.0.tgz
	https://registry.yarnpkg.com/pkg-dir/-/pkg-dir-4.2.0.tgz
	https://registry.yarnpkg.com/pkg-up/-/pkg-up-2.0.0.tgz
	https://registry.yarnpkg.com/portfinder/-/portfinder-1.0.26.tgz
	https://registry.yarnpkg.com/posix-character-classes/-/posix-character-classes-0.1.1.tgz
	https://registry.yarnpkg.com/postcss-functions/-/postcss-functions-3.0.0.tgz
	https://registry.yarnpkg.com/postcss-js/-/postcss-js-3.0.3.tgz
	https://registry.yarnpkg.com/postcss-modules-extract-imports/-/postcss-modules-extract-imports-2.0.0.tgz
	https://registry.yarnpkg.com/postcss-modules-local-by-default/-/postcss-modules-local-by-default-3.0.2.tgz
	https://registry.yarnpkg.com/postcss-modules-scope/-/postcss-modules-scope-2.1.1.tgz
	https://registry.yarnpkg.com/postcss-modules-values/-/postcss-modules-values-3.0.0.tgz
	https://registry.yarnpkg.com/postcss-nested/-/postcss-nested-5.0.3.tgz
	https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.2.tgz
	https://registry.yarnpkg.com/postcss-selector-parser/-/postcss-selector-parser-6.0.4.tgz
	https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-3.3.1.tgz
	https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.0.2.tgz
	https://registry.yarnpkg.com/postcss-value-parser/-/postcss-value-parser-4.1.0.tgz
	https://registry.yarnpkg.com/postcss/-/postcss-6.0.22.tgz
	https://registry.yarnpkg.com/postcss/-/postcss-7.0.24.tgz
	https://registry.yarnpkg.com/postcss/-/postcss-8.2.1.tgz
	https://registry.yarnpkg.com/prelude-ls/-/prelude-ls-1.2.1.tgz
	https://registry.yarnpkg.com/pretty-hrtime/-/pretty-hrtime-1.0.3.tgz
	https://registry.yarnpkg.com/process-nextick-args/-/process-nextick-args-2.0.0.tgz
	https://registry.yarnpkg.com/process/-/process-0.11.10.tgz
	https://registry.yarnpkg.com/process/-/process-0.5.2.tgz
	https://registry.yarnpkg.com/progress/-/progress-2.0.3.tgz
	https://registry.yarnpkg.com/promise-inflight/-/promise-inflight-1.0.1.tgz
	https://registry.yarnpkg.com/prop-types/-/prop-types-15.7.2.tgz
	https://registry.yarnpkg.com/property-expr/-/property-expr-2.0.2.tgz
	https://registry.yarnpkg.com/proxy-addr/-/proxy-addr-2.0.5.tgz
	https://registry.yarnpkg.com/prr/-/prr-1.0.1.tgz
	https://registry.yarnpkg.com/public-encrypt/-/public-encrypt-4.0.2.tgz
	https://registry.yarnpkg.com/pump/-/pump-2.0.1.tgz
	https://registry.yarnpkg.com/pump/-/pump-3.0.0.tgz
	https://registry.yarnpkg.com/pumpify/-/pumpify-1.5.1.tgz
	https://registry.yarnpkg.com/punycode/-/punycode-1.3.2.tgz
	https://registry.yarnpkg.com/punycode/-/punycode-1.4.1.tgz
	https://registry.yarnpkg.com/punycode/-/punycode-2.1.1.tgz
	https://registry.yarnpkg.com/purgecss/-/purgecss-3.1.3.tgz
	https://registry.yarnpkg.com/qr.js/-/qr.js-0.0.0.tgz
	https://registry.yarnpkg.com/qrcode.react/-/qrcode.react-1.0.1.tgz
	https://registry.yarnpkg.com/qs/-/qs-6.7.0.tgz
	https://registry.yarnpkg.com/query-string/-/query-string-6.7.0.tgz
	https://registry.yarnpkg.com/querystring-es3/-/querystring-es3-0.2.1.tgz
	https://registry.yarnpkg.com/querystring/-/querystring-0.2.0.tgz
	https://registry.yarnpkg.com/querystringify/-/querystringify-2.1.0.tgz
	https://registry.yarnpkg.com/queue-microtask/-/queue-microtask-1.2.3.tgz
	https://registry.yarnpkg.com/randombytes/-/randombytes-2.0.6.tgz
	https://registry.yarnpkg.com/randombytes/-/randombytes-2.1.0.tgz
	https://registry.yarnpkg.com/randomfill/-/randomfill-1.0.4.tgz
	https://registry.yarnpkg.com/range-parser/-/range-parser-1.2.1.tgz
	https://registry.yarnpkg.com/raw-body/-/raw-body-2.4.0.tgz
	https://registry.yarnpkg.com/rc/-/rc-1.2.8.tgz
	https://registry.yarnpkg.com/react-async-script/-/react-async-script-1.1.1.tgz
	https://registry.yarnpkg.com/react-copy-to-clipboard/-/react-copy-to-clipboard-5.0.2.tgz
	https://registry.yarnpkg.com/@hot-loader/react-dom/-/react-dom-16.11.0.tgz -> @hot-loader-react-dom-16.11.0.tgz
	https://registry.yarnpkg.com/react-fast-compare/-/react-fast-compare-2.0.4.tgz
	https://registry.yarnpkg.com/react-fast-compare/-/react-fast-compare-3.2.0.tgz
	https://registry.yarnpkg.com/react-ga/-/react-ga-3.1.2.tgz
	https://registry.yarnpkg.com/react-google-recaptcha/-/react-google-recaptcha-2.0.1.tgz
	https://registry.yarnpkg.com/react-hot-loader/-/react-hot-loader-4.12.21.tgz
	https://registry.yarnpkg.com/react-i18next/-/react-i18next-11.2.1.tgz
	https://registry.yarnpkg.com/react-is/-/react-is-16.8.6.tgz
	https://registry.yarnpkg.com/react-lifecycles-compat/-/react-lifecycles-compat-3.0.4.tgz
	https://registry.yarnpkg.com/react-router-dom/-/react-router-dom-5.1.2.tgz
	https://registry.yarnpkg.com/react-router/-/react-router-5.1.2.tgz
	https://registry.yarnpkg.com/react-transition-group/-/react-transition-group-4.4.1.tgz
	https://registry.yarnpkg.com/react/-/react-16.13.1.tgz
	https://registry.yarnpkg.com/read-pkg-up/-/read-pkg-up-3.0.0.tgz
	https://registry.yarnpkg.com/read-pkg/-/read-pkg-3.0.0.tgz
	https://registry.yarnpkg.com/readable-stream/-/readable-stream-2.3.6.tgz
	https://registry.yarnpkg.com/readable-stream/-/readable-stream-3.1.1.tgz
	https://registry.yarnpkg.com/readdirp/-/readdirp-2.2.1.tgz
	https://registry.yarnpkg.com/readdirp/-/readdirp-3.4.0.tgz
	https://registry.yarnpkg.com/readdirp/-/readdirp-3.5.0.tgz
	https://registry.yarnpkg.com/reaptcha/-/reaptcha-1.7.2.tgz
	https://registry.yarnpkg.com/reduce-css-calc/-/reduce-css-calc-2.1.7.tgz
	https://registry.yarnpkg.com/redux-devtools-extension/-/redux-devtools-extension-2.13.8.tgz
	https://registry.yarnpkg.com/redux-thunk/-/redux-thunk-2.3.0.tgz
	https://registry.yarnpkg.com/redux/-/redux-4.0.4.tgz
	https://registry.yarnpkg.com/redux/-/redux-4.0.5.tgz
	https://registry.yarnpkg.com/regenerate-unicode-properties/-/regenerate-unicode-properties-8.2.0.tgz
	https://registry.yarnpkg.com/regenerate/-/regenerate-1.4.0.tgz
	https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.11.1.tgz
	https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.2.tgz
	https://registry.yarnpkg.com/regenerator-runtime/-/regenerator-runtime-0.13.5.tgz
	https://registry.yarnpkg.com/regenerator-transform/-/regenerator-transform-0.14.5.tgz
	https://registry.yarnpkg.com/regex-not/-/regex-not-1.0.2.tgz
	https://registry.yarnpkg.com/regexp.prototype.flags/-/regexp.prototype.flags-1.3.1.tgz
	https://registry.yarnpkg.com/regexpp/-/regexpp-3.0.0.tgz
	https://registry.yarnpkg.com/regexpp/-/regexpp-3.1.0.tgz
	https://registry.yarnpkg.com/regexpu-core/-/regexpu-core-4.7.1.tgz
	https://registry.yarnpkg.com/regjsgen/-/regjsgen-0.5.2.tgz
	https://registry.yarnpkg.com/regjsparser/-/regjsparser-0.6.4.tgz
	https://registry.yarnpkg.com/remove-trailing-separator/-/remove-trailing-separator-1.1.0.tgz
	https://registry.yarnpkg.com/repeat-element/-/repeat-element-1.1.2.tgz
	https://registry.yarnpkg.com/repeat-string/-/repeat-string-1.6.1.tgz
	https://registry.yarnpkg.com/require-directory/-/require-directory-2.1.1.tgz
	https://registry.yarnpkg.com/require-from-string/-/require-from-string-2.0.2.tgz
	https://registry.yarnpkg.com/require-main-filename/-/require-main-filename-2.0.0.tgz
	https://registry.yarnpkg.com/requires-port/-/requires-port-1.0.0.tgz
	https://registry.yarnpkg.com/resolve-cwd/-/resolve-cwd-2.0.0.tgz
	https://registry.yarnpkg.com/resolve-dir/-/resolve-dir-1.0.1.tgz
	https://registry.yarnpkg.com/resolve-from/-/resolve-from-3.0.0.tgz
	https://registry.yarnpkg.com/resolve-from/-/resolve-from-4.0.0.tgz
	https://registry.yarnpkg.com/resolve-pathname/-/resolve-pathname-2.2.0.tgz
	https://registry.yarnpkg.com/resolve-url/-/resolve-url-0.2.1.tgz
	https://registry.yarnpkg.com/resolve/-/resolve-1.12.0.tgz
	https://registry.yarnpkg.com/resolve/-/resolve-1.17.0.tgz
	https://registry.yarnpkg.com/resolve/-/resolve-1.19.0.tgz
	https://registry.yarnpkg.com/resolve/-/resolve-1.20.0.tgz
	https://registry.yarnpkg.com/resolve/-/resolve-2.0.0-next.3.tgz
	https://registry.yarnpkg.com/ret/-/ret-0.1.15.tgz
	https://registry.yarnpkg.com/retry/-/retry-0.12.0.tgz
	https://registry.yarnpkg.com/reusify/-/reusify-1.0.4.tgz
	https://registry.yarnpkg.com/rimraf/-/rimraf-2.7.1.tgz
	https://registry.yarnpkg.com/rimraf/-/rimraf-3.0.2.tgz
	https://registry.yarnpkg.com/ripemd160/-/ripemd160-2.0.2.tgz
	https://registry.yarnpkg.com/run-parallel/-/run-parallel-1.2.0.tgz
	https://registry.yarnpkg.com/run-queue/-/run-queue-1.0.3.tgz
	https://registry.yarnpkg.com/rxjs-compat/-/rxjs-compat-6.6.3.tgz
	https://registry.yarnpkg.com/safe-buffer/-/safe-buffer-5.1.2.tgz
	https://registry.yarnpkg.com/safe-regex/-/safe-regex-1.1.0.tgz
	https://registry.yarnpkg.com/safer-buffer/-/safer-buffer-2.1.2.tgz
	https://registry.yarnpkg.com/sax/-/sax-1.2.4.tgz
	https://registry.yarnpkg.com/scheduler/-/scheduler-0.17.0.tgz
	https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.7.0.tgz
	https://registry.yarnpkg.com/schema-utils/-/schema-utils-1.0.0.tgz
	https://registry.yarnpkg.com/schema-utils/-/schema-utils-2.6.1.tgz
	https://registry.yarnpkg.com/select-hose/-/select-hose-2.0.0.tgz
	https://registry.yarnpkg.com/selfsigned/-/selfsigned-1.10.7.tgz
	https://registry.yarnpkg.com/semver/-/semver-5.7.1.tgz
	https://registry.yarnpkg.com/semver/-/semver-7.0.0.tgz
	https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz
	https://registry.yarnpkg.com/semver/-/semver-7.3.2.tgz
	https://registry.yarnpkg.com/send/-/send-0.17.1.tgz
	https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-3.1.0.tgz
	https://registry.yarnpkg.com/serialize-javascript/-/serialize-javascript-4.0.0.tgz
	https://registry.yarnpkg.com/serve-index/-/serve-index-1.9.1.tgz
	https://registry.yarnpkg.com/serve-static/-/serve-static-1.14.1.tgz
	https://registry.yarnpkg.com/set-blocking/-/set-blocking-2.0.0.tgz
	https://registry.yarnpkg.com/set-value/-/set-value-0.4.3.tgz
	https://registry.yarnpkg.com/set-value/-/set-value-2.0.0.tgz
	https://registry.yarnpkg.com/setimmediate/-/setimmediate-1.0.5.tgz
	https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.0.tgz
	https://registry.yarnpkg.com/setprototypeof/-/setprototypeof-1.1.1.tgz
	https://registry.yarnpkg.com/sha.js/-/sha.js-2.4.11.tgz
	https://registry.yarnpkg.com/shallowequal/-/shallowequal-1.1.0.tgz
	https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz
	https://registry.yarnpkg.com/shebang-command/-/shebang-command-2.0.0.tgz
	https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz
	https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-3.0.0.tgz
	https://registry.yarnpkg.com/side-channel/-/side-channel-1.0.4.tgz
	https://registry.yarnpkg.com/signal-exit/-/signal-exit-3.0.2.tgz
	https://registry.yarnpkg.com/simple-swizzle/-/simple-swizzle-0.2.2.tgz
	https://registry.yarnpkg.com/slash/-/slash-3.0.0.tgz
	https://registry.yarnpkg.com/slice-ansi/-/slice-ansi-4.0.0.tgz
	https://registry.yarnpkg.com/snapdragon-node/-/snapdragon-node-2.1.1.tgz
	https://registry.yarnpkg.com/snapdragon-util/-/snapdragon-util-3.0.1.tgz
	https://registry.yarnpkg.com/snapdragon/-/snapdragon-0.8.2.tgz
	https://registry.yarnpkg.com/sockette/-/sockette-2.0.6.tgz
	https://registry.yarnpkg.com/sockjs-client/-/sockjs-client-1.4.0.tgz
	https://registry.yarnpkg.com/sockjs/-/sockjs-0.3.20.tgz
	https://registry.yarnpkg.com/source-list-map/-/source-list-map-2.0.0.tgz
	https://registry.yarnpkg.com/source-map-loader/-/source-map-loader-1.0.1.tgz
	https://registry.yarnpkg.com/source-map-resolve/-/source-map-resolve-0.5.2.tgz
	https://registry.yarnpkg.com/source-map-support/-/source-map-support-0.5.13.tgz
	https://registry.yarnpkg.com/source-map-url/-/source-map-url-0.4.0.tgz
	https://registry.yarnpkg.com/source-map/-/source-map-0.5.7.tgz
	https://registry.yarnpkg.com/source-map/-/source-map-0.6.1.tgz
	https://registry.yarnpkg.com/source-map/-/source-map-0.7.3.tgz
	https://registry.yarnpkg.com/spdx-correct/-/spdx-correct-3.1.1.tgz
	https://registry.yarnpkg.com/spdx-exceptions/-/spdx-exceptions-2.3.0.tgz
	https://registry.yarnpkg.com/spdx-expression-parse/-/spdx-expression-parse-3.0.1.tgz
	https://registry.yarnpkg.com/spdx-license-ids/-/spdx-license-ids-3.0.5.tgz
	https://registry.yarnpkg.com/spdy-transport/-/spdy-transport-3.0.0.tgz
	https://registry.yarnpkg.com/spdy/-/spdy-4.0.2.tgz
	https://registry.yarnpkg.com/split-on-first/-/split-on-first-1.1.0.tgz
	https://registry.yarnpkg.com/split-string/-/split-string-3.1.0.tgz
	https://registry.yarnpkg.com/sprintf-js/-/sprintf-js-1.0.3.tgz
	https://registry.yarnpkg.com/ssri/-/ssri-6.0.1.tgz
	https://registry.yarnpkg.com/ssri/-/ssri-8.0.0.tgz
	https://registry.yarnpkg.com/static-extend/-/static-extend-0.1.2.tgz
	https://registry.yarnpkg.com/statuses/-/statuses-1.5.0.tgz
	https://registry.yarnpkg.com/stream-browserify/-/stream-browserify-2.0.1.tgz
	https://registry.yarnpkg.com/stream-each/-/stream-each-1.2.2.tgz
	https://registry.yarnpkg.com/stream-http/-/stream-http-2.8.3.tgz
	https://registry.yarnpkg.com/stream-shift/-/stream-shift-1.0.0.tgz
	https://registry.yarnpkg.com/strict-uri-encode/-/strict-uri-encode-2.0.0.tgz
	https://registry.yarnpkg.com/string-similarity/-/string-similarity-4.0.3.tgz
	https://registry.yarnpkg.com/string-width/-/string-width-1.0.2.tgz
	https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz
	https://registry.yarnpkg.com/string-width/-/string-width-3.1.0.tgz
	https://registry.yarnpkg.com/string-width/-/string-width-4.2.2.tgz
	https://registry.yarnpkg.com/string.prototype.matchall/-/string.prototype.matchall-4.0.5.tgz
	https://registry.yarnpkg.com/string.prototype.trimend/-/string.prototype.trimend-1.0.4.tgz
	https://registry.yarnpkg.com/string.prototype.trimstart/-/string.prototype.trimstart-1.0.4.tgz
	https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.2.0.tgz
	https://registry.yarnpkg.com/string_decoder/-/string_decoder-1.1.1.tgz
	https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-3.0.1.tgz
	https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-4.0.0.tgz
	https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-5.2.0.tgz
	https://registry.yarnpkg.com/strip-ansi/-/strip-ansi-6.0.0.tgz
	https://registry.yarnpkg.com/strip-bom/-/strip-bom-3.0.0.tgz
	https://registry.yarnpkg.com/strip-eof/-/strip-eof-1.0.0.tgz
	https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.0.tgz
	https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-3.1.1.tgz
	https://registry.yarnpkg.com/strip-json-comments/-/strip-json-comments-2.0.1.tgz
	https://registry.yarnpkg.com/style-loader/-/style-loader-1.2.1.tgz
	https://registry.yarnpkg.com/styled-components-breakpoint/-/styled-components-breakpoint-3.0.0-preview.20.tgz
	https://registry.yarnpkg.com/styled-components/-/styled-components-5.2.1.tgz
	https://registry.yarnpkg.com/supports-color/-/supports-color-5.5.0.tgz
	https://registry.yarnpkg.com/supports-color/-/supports-color-6.1.0.tgz
	https://registry.yarnpkg.com/supports-color/-/supports-color-7.1.0.tgz
	https://registry.yarnpkg.com/svg-url-loader/-/svg-url-loader-6.0.0.tgz
	https://registry.yarnpkg.com/swr/-/swr-0.2.3.tgz
	https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-1.2.0.tgz
	https://registry.yarnpkg.com/symbol-observable/-/symbol-observable-2.0.3.tgz
	https://registry.yarnpkg.com/synchronous-promise/-/synchronous-promise-2.0.13.tgz
	https://registry.yarnpkg.com/table/-/table-6.7.1.tgz
	https://registry.yarnpkg.com/tailwindcss/-/tailwindcss-2.0.2.tgz
	https://registry.yarnpkg.com/tapable/-/tapable-1.1.3.tgz
	https://registry.yarnpkg.com/tar/-/tar-4.4.4.tgz
	https://registry.yarnpkg.com/tar/-/tar-6.0.2.tgz
	https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-1.4.4.tgz
	https://registry.yarnpkg.com/terser-webpack-plugin/-/terser-webpack-plugin-3.0.6.tgz
	https://registry.yarnpkg.com/terser/-/terser-4.3.1.tgz
	https://registry.yarnpkg.com/terser/-/terser-4.8.0.tgz
	https://registry.yarnpkg.com/text-table/-/text-table-0.2.0.tgz
	https://registry.yarnpkg.com/through2/-/through2-2.0.3.tgz
	https://registry.yarnpkg.com/thunky/-/thunky-1.0.3.tgz
	https://registry.yarnpkg.com/timers-browserify/-/timers-browserify-2.0.10.tgz
	https://registry.yarnpkg.com/timsort/-/timsort-0.3.0.tgz
	https://registry.yarnpkg.com/tiny-invariant/-/tiny-invariant-1.0.4.tgz
	https://registry.yarnpkg.com/tiny-warning/-/tiny-warning-1.0.2.tgz
	https://registry.yarnpkg.com/to-arraybuffer/-/to-arraybuffer-1.0.1.tgz
	https://registry.yarnpkg.com/to-fast-properties/-/to-fast-properties-2.0.0.tgz
	https://registry.yarnpkg.com/to-object-path/-/to-object-path-0.3.0.tgz
	https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-2.1.1.tgz
	https://registry.yarnpkg.com/to-regex-range/-/to-regex-range-5.0.1.tgz
	https://registry.yarnpkg.com/to-regex/-/to-regex-3.0.2.tgz
	https://registry.yarnpkg.com/toggle-selection/-/toggle-selection-1.0.6.tgz
	https://registry.yarnpkg.com/toidentifier/-/toidentifier-1.0.0.tgz
	https://registry.yarnpkg.com/toposort/-/toposort-2.0.2.tgz
	https://registry.yarnpkg.com/tr46/-/tr46-2.0.2.tgz
	https://registry.yarnpkg.com/tryer/-/tryer-1.0.1.tgz
	https://registry.yarnpkg.com/ts-toolbelt/-/ts-toolbelt-8.0.7.tgz
	https://registry.yarnpkg.com/tsconfig-paths/-/tsconfig-paths-3.9.0.tgz
	https://registry.yarnpkg.com/tslib/-/tslib-1.11.1.tgz
	https://registry.yarnpkg.com/tslib/-/tslib-1.10.0.tgz
	https://registry.yarnpkg.com/tsutils/-/tsutils-3.17.1.tgz
	https://registry.yarnpkg.com/tty-browserify/-/tty-browserify-0.0.0.tgz
	https://registry.yarnpkg.com/twin.macro/-/twin.macro-2.0.7.tgz
	https://registry.yarnpkg.com/type-check/-/type-check-0.4.0.tgz
	https://registry.yarnpkg.com/type-fest/-/type-fest-0.20.2.tgz
	https://registry.yarnpkg.com/type-fest/-/type-fest-0.8.1.tgz
	https://registry.yarnpkg.com/type-is/-/type-is-1.6.18.tgz
	https://registry.yarnpkg.com/typedarray/-/typedarray-0.0.6.tgz
	https://registry.yarnpkg.com/typescript/-/typescript-4.2.4.tgz
	https://registry.yarnpkg.com/unbox-primitive/-/unbox-primitive-1.0.1.tgz
	https://registry.yarnpkg.com/unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-1.0.4.tgz
	https://registry.yarnpkg.com/unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-1.0.4.tgz
	https://registry.yarnpkg.com/unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-1.2.0.tgz
	https://registry.yarnpkg.com/unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-1.0.4.tgz
	https://registry.yarnpkg.com/union-value/-/union-value-1.0.0.tgz
	https://registry.yarnpkg.com/uniq/-/uniq-1.0.1.tgz
	https://registry.yarnpkg.com/unique-filename/-/unique-filename-1.1.1.tgz
	https://registry.yarnpkg.com/unique-slug/-/unique-slug-2.0.0.tgz
	https://registry.yarnpkg.com/universalify/-/universalify-1.0.0.tgz
	https://registry.yarnpkg.com/unpipe/-/unpipe-1.0.0.tgz
	https://registry.yarnpkg.com/unset-value/-/unset-value-1.0.0.tgz
	https://registry.yarnpkg.com/upath/-/upath-1.2.0.tgz
	https://registry.yarnpkg.com/uri-js/-/uri-js-4.2.2.tgz
	https://registry.yarnpkg.com/urix/-/urix-0.1.0.tgz
	https://registry.yarnpkg.com/url-parse/-/url-parse-1.4.4.tgz
	https://registry.yarnpkg.com/url/-/url-0.11.0.tgz
	https://registry.yarnpkg.com/use-memo-one/-/use-memo-one-1.1.1.tgz
	https://registry.yarnpkg.com/use/-/use-3.1.0.tgz
	https://registry.yarnpkg.com/util-deprecate/-/util-deprecate-1.0.2.tgz
	https://registry.yarnpkg.com/util/-/util-0.10.3.tgz
	https://registry.yarnpkg.com/util/-/util-0.11.1.tgz
	https://registry.yarnpkg.com/utils-merge/-/utils-merge-1.0.1.tgz
	https://registry.yarnpkg.com/uuid/-/uuid-3.3.2.tgz
	https://registry.yarnpkg.com/uuid/-/uuid-3.4.0.tgz
	https://registry.yarnpkg.com/v8-compile-cache/-/v8-compile-cache-2.1.1.tgz
	https://registry.yarnpkg.com/validate-npm-package-license/-/validate-npm-package-license-3.0.4.tgz
	https://registry.yarnpkg.com/value-equal/-/value-equal-0.4.0.tgz
	https://registry.yarnpkg.com/vary/-/vary-1.1.2.tgz
	https://registry.yarnpkg.com/vm-browserify/-/vm-browserify-1.1.0.tgz
	https://registry.yarnpkg.com/void-elements/-/void-elements-2.0.1.tgz
	https://registry.yarnpkg.com/watchpack-chokidar2/-/watchpack-chokidar2-2.0.0.tgz
	https://registry.yarnpkg.com/watchpack/-/watchpack-1.7.2.tgz
	https://registry.yarnpkg.com/wbuf/-/wbuf-1.7.3.tgz
	https://registry.yarnpkg.com/webidl-conversions/-/webidl-conversions-5.0.0.tgz
	https://registry.yarnpkg.com/webpack-assets-manifest/-/webpack-assets-manifest-3.1.1.tgz
	https://registry.yarnpkg.com/webpack-bundle-analyzer/-/webpack-bundle-analyzer-3.8.0.tgz
	https://registry.yarnpkg.com/webpack-cli/-/webpack-cli-3.3.12.tgz
	https://registry.yarnpkg.com/webpack-dev-middleware/-/webpack-dev-middleware-3.7.2.tgz
	https://registry.yarnpkg.com/webpack-dev-server/-/webpack-dev-server-3.11.0.tgz
	https://registry.yarnpkg.com/webpack-log/-/webpack-log-2.0.0.tgz
	https://registry.yarnpkg.com/webpack-sources/-/webpack-sources-1.4.3.tgz
	https://registry.yarnpkg.com/webpack/-/webpack-4.43.0.tgz
	https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.6.5.tgz
	https://registry.yarnpkg.com/websocket-driver/-/websocket-driver-0.7.0.tgz
	https://registry.yarnpkg.com/websocket-extensions/-/websocket-extensions-0.1.3.tgz
	https://registry.yarnpkg.com/whatwg-mimetype/-/whatwg-mimetype-2.3.0.tgz
	https://registry.yarnpkg.com/whatwg-url/-/whatwg-url-8.1.0.tgz
	https://registry.yarnpkg.com/which-boxed-primitive/-/which-boxed-primitive-1.0.2.tgz
	https://registry.yarnpkg.com/which-module/-/which-module-2.0.0.tgz
	https://registry.yarnpkg.com/which/-/which-1.3.1.tgz
	https://registry.yarnpkg.com/which/-/which-2.0.2.tgz
	https://registry.yarnpkg.com/wide-align/-/wide-align-1.1.3.tgz
	https://registry.yarnpkg.com/word-wrap/-/word-wrap-1.2.3.tgz
	https://registry.yarnpkg.com/worker-farm/-/worker-farm-1.7.0.tgz
	https://registry.yarnpkg.com/wrap-ansi/-/wrap-ansi-5.1.0.tgz
	https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz
	https://registry.yarnpkg.com/ws/-/ws-6.2.1.tgz
	https://registry.yarnpkg.com/xtend/-/xtend-4.0.1.tgz
	https://registry.yarnpkg.com/xtend/-/xtend-4.0.2.tgz
	https://registry.yarnpkg.com/xterm-addon-attach/-/xterm-addon-attach-0.6.0.tgz
	https://registry.yarnpkg.com/xterm-addon-fit/-/xterm-addon-fit-0.4.0.tgz
	https://registry.yarnpkg.com/xterm-addon-search-bar/-/xterm-addon-search-bar-0.2.0.tgz
	https://registry.yarnpkg.com/xterm-addon-search/-/xterm-addon-search-0.7.0.tgz
	https://registry.yarnpkg.com/xterm-addon-web-links/-/xterm-addon-web-links-0.4.0.tgz
	https://registry.yarnpkg.com/xterm/-/xterm-4.15.0.tgz
	https://registry.yarnpkg.com/y18n/-/y18n-4.0.0.tgz
	https://registry.yarnpkg.com/yallist/-/yallist-3.0.2.tgz
	https://registry.yarnpkg.com/yallist/-/yallist-4.0.0.tgz
	https://registry.yarnpkg.com/yaml/-/yaml-1.10.0.tgz
	https://registry.yarnpkg.com/yargs-parser/-/yargs-parser-13.1.2.tgz
	https://registry.yarnpkg.com/yargs/-/yargs-13.3.2.tgz
	https://registry.yarnpkg.com/yarn-deduplicate/-/yarn-deduplicate-1.1.1.tgz
	https://registry.yarnpkg.com/yup/-/yup-0.29.1.tgz
	https://registry.yarnpkg.com/caniuse-lite/-/caniuse-lite-1.0.30001170.tgz
	https://github.com/pterodactyl/panel/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
KEYWORDS="amd64"
IUSE=""

# composer requires network
RESTRICT="mirror network-sandbox"

BDEPEND="
	sys-apps/yarn
	=net-libs/nodejs-14*
"
DEPEND="
	dev-db/redis
	>=dev-lang/php-7.4:*[cli,ssl,gd,mysql,pdo,unicode,tokenizer,bcmath,xml,curl,zip,fpm,sodium]
	dev-php/composer
	virtual/mysql
"
RDEPEND="${DEPEND}"
need_httpd_cgi

src_unpack() {
	unpack ${P}.tar.gz
	mv panel-${PV} ${P}
}

src_prepare() {
	# cleanup
	find ${S} -type f -name '.git*' -delete
	rm -rf .github

	default
}

src_configure() {
	yarn config set disable-self-update-check true || die
	yarn config set nodedir /usr/include/node || die
	yarn config set yarn-offline-mirror "${DISTDIR}" || die
	yarn install --frozen-lockfile --offline --no-progress || die
}

src_compile() {
	einfo "building web assets"
	yarn run build:production || die
	rm -rf node_modules

	einfo "downloading php dependencies"
	composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist || die
}

src_install() {
	cp .env.example .env

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/.env
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config
	webapp_serverowned -R "${MY_HTDOCSDIR}"/storage
	webapp_serverowned -R "${MY_HTDOCSDIR}"/bootstrap/cache
	webapp_configfile "${MY_HTDOCSDIR}"/.env
	webapp_configfile "${MY_HTDOCSDIR}"/config
	webapp_configfile "${MY_HTDOCSDIR}"/storage

	webapp_src_install

	newinitd "${FILESDIR}"/pteroq.init pteroq
	newconfd "${FILESDIR}"/pteroq.conf pteroq

	insinto /etc/cron.d
	newins "${FILESDIR}"/pterodactyl-panel.cron ${PN}

	insinto /usr/libexec/${PN}
	insopts -m755
	doins "${FILESDIR}"/run-schedule
}