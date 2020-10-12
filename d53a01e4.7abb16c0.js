(window.webpackJsonp=window.webpackJsonp||[]).push([[37],{101:function(e,t,r){"use strict";r.d(t,"a",(function(){return p})),r.d(t,"b",(function(){return m}));var n=r(0),o=r.n(n);function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function u(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){i(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function c(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},i=Object.keys(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var s=o.a.createContext({}),l=function(e){var t=o.a.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):u(u({},t),e)),r},p=function(e){var t=l(e.components);return o.a.createElement(s.Provider,{value:t},e.children)},b={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},d=o.a.forwardRef((function(e,t){var r=e.components,n=e.mdxType,i=e.originalType,a=e.parentName,s=c(e,["components","mdxType","originalType","parentName"]),p=l(r),d=n,m=p["".concat(a,".").concat(d)]||p[d]||b[d]||i;return r?o.a.createElement(m,u(u({ref:t},s),{},{components:r})):o.a.createElement(m,u({ref:t},s))}));function m(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var i=r.length,a=new Array(i);a[0]=d;var u={};for(var c in t)hasOwnProperty.call(t,c)&&(u[c]=t[c]);u.originalType=e,u.mdxType="string"==typeof e?e:n,a[1]=u;for(var s=2;s<i;s++)a[s]=r[s];return o.a.createElement.apply(null,a)}return o.a.createElement.apply(null,r)}d.displayName="MDXCreateElement"},91:function(e,t,r){"use strict";r.r(t),r.d(t,"frontMatter",(function(){return a})),r.d(t,"metadata",(function(){return u})),r.d(t,"rightToc",(function(){return c})),r.d(t,"default",(function(){return l}));var n=r(2),o=r(6),i=(r(0),r(101)),a={id:"contributing",title:"Contributing",sidebar_label:"Contributing"},u={unversionedId:"support/contributing",id:"support/contributing",isDocsHomePage:!1,title:"Contributing",description:"Like any other open source projects, there are multiple ways to contribute to this project:",source:"@site/docs\\support\\contributing.md",slug:"/support/contributing",permalink:"/docs/support/contributing",editUrl:"https://github.com/StrykerDG/StrykerDG.FarmForge/tree/master/StrykerDG.FarmForge.Documentation/docs/support/contributing.md",version:"current",sidebar_label:"Contributing",sidebar:"someSidebar",previous:{title:"Issues",permalink:"/docs/support/issues"},next:{title:"Introduction",permalink:"/docs/development/dev_introduction"}},c=[],s={rightToc:c};function l(e){var t=e.components,r=Object(o.a)(e,["components"]);return Object(i.b)("wrapper",Object(n.a)({},s,r,{components:t,mdxType:"MDXLayout"}),Object(i.b)("p",null,"Like any other open source projects, there are multiple ways to contribute to this project:"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"As a developer, depending on your skills and experience,"),Object(i.b)("li",{parentName:"ul"},"As a user who enjoys the project and wants to help.")),Object(i.b)("h5",{id:"reporting-bugs"},"Reporting Bugs"),Object(i.b)("p",null,"If you found something broken or not working properly, feel free to create an issue in Github with as much information as possible, such as logs and how to reproduce the problem. Before opening the issue, make sure that:"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"You have read this documentation,"),Object(i.b)("li",{parentName:"ul"},"You are using the latest version of project,"),Object(i.b)("li",{parentName:"ul"},"You already searched other issues to see if your problem or request was already reported.")),Object(i.b)("h5",{id:"improving-the-documentation"},"Improving the Documentation"),Object(i.b)("p",null,"You can improve this documentation by forking its repository, updating the content and sending a pull request."),Object(i.b)("h4",{id:"we-\ufe0f-pull-requests"},"We \u2764\ufe0f Pull Requests"),Object(i.b)("p",null,"A pull request does not need to be a fix for a bug or implementing something new. Software can always be improved, legacy code removed and tests are always welcome!"),Object(i.b)("p",null,"Please do not be afraid of contributing code, make sure it follows these rules:"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"Your code compiles, does not break any of the existing code in the master branch and does not cause conflicts,"),Object(i.b)("li",{parentName:"ul"},"The code is readable and has comments, that aren\u2019t superfluous or unnecessary,"),Object(i.b)("li",{parentName:"ul"},"An overview or context is provided as body of the Pull Request. It does not need to be too extensive.")),Object(i.b)("p",null,"Extra points if your code comes with tests!"))}l.isMDXComponent=!0}}]);