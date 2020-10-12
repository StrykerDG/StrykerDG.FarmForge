(window.webpackJsonp=window.webpackJsonp||[]).push([[9],{101:function(e,t,n){"use strict";n.d(t,"a",(function(){return b})),n.d(t,"b",(function(){return m}));var r=n(0),o=n.n(r);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=o.a.createContext({}),p=function(e){var t=o.a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},b=function(e){var t=p(e.components);return o.a.createElement(s.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},u=o.a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,a=e.originalType,i=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),b=p(n),u=r,m=b["".concat(i,".").concat(u)]||b[u]||d[u]||a;return n?o.a.createElement(m,c(c({ref:t},s),{},{components:n})):o.a.createElement(m,c({ref:t},s))}));function m(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var a=n.length,i=new Array(a);i[0]=u;var c={};for(var l in t)hasOwnProperty.call(t,l)&&(c[l]=t[l]);c.originalType=e,c.mdxType="string"==typeof e?e:r,i[1]=c;for(var s=2;s<a;s++)i[s]=n[s];return o.a.createElement.apply(null,i)}return o.a.createElement.apply(null,n)}u.displayName="MDXCreateElement"},62:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return i})),n.d(t,"metadata",(function(){return c})),n.d(t,"rightToc",(function(){return l})),n.d(t,"default",(function(){return p}));var r=n(2),o=n(6),a=(n(0),n(101)),i={id:"migrations",title:"Migrations",sidebar_label:"Migrations"},c={unversionedId:"development/migrations",id:"development/migrations",isDocsHomePage:!1,title:"Migrations",description:"Introduction",source:"@site/docs\\development\\migrations.md",slug:"/development/migrations",permalink:"/docs/development/migrations",editUrl:"https://github.com/StrykerDG/StrykerDG.FarmForge/tree/master/StrykerDG.FarmForge.Documentation/docs/development/migrations.md",version:"current",sidebar_label:"Migrations",sidebar:"someSidebar",previous:{title:"Data Model",permalink:"/docs/development/data_model"},next:{title:"Actors",permalink:"/docs/development/actors"}},l=[{value:"Introduction",id:"introduction",children:[]},{value:"Migration Structure",id:"migration-structure",children:[{value:"Up()",id:"up",children:[]},{value:"Down()",id:"down",children:[]}]}],s={rightToc:l};function p(e){var t=e.components,n=Object(o.a)(e,["components"]);return Object(a.b)("wrapper",Object(r.a)({},s,n,{components:t,mdxType:"MDXLayout"}),Object(a.b)("h2",{id:"introduction"},"Introduction"),Object(a.b)("p",null,"Migrations in FarmForge are created using ",Object(a.b)("a",Object(r.a)({parentName:"p"},{href:"https://fluentmigrator.github.io/index.html"}),"FluentMigrator")," and take place when the FarmForge API\nstarts."),Object(a.b)("p",null,"The code that runs the migration is in Program.cs of the Api project, and within\nthe CreateServices Method"),Object(a.b)("pre",null,Object(a.b)("code",Object(r.a)({parentName:"pre"},{}),'public static IServiceProvider CreateServices(ApiSettings settings)\n{\n    return new ServiceCollection()\n        .AddFluentMigratorCore()\n        .ConfigureRunner(rb =>\n        {\n            if (settings.DatabaseType == DatabaseType.SQLITE)\n                rb.AddSQLite()\n                .WithGlobalConnectionString(settings.ConnectionStrin["Database"])\n                .ScanIn(typeof(Release_0001).Assembly).For\n                .Migrations();\n\n            else if (settings.DatabaseType == DatabaseType.SQLSERVER)\n                rb.AddSqlServer()\n                .WithGlobalConnectionString(settings.ConnectionStrin["Database"])\n                .ScanIn(typeof(Release_0001).Assembly).For\n                .Migrations();\n        })\n        .AddLogging(lb => lb.AddFluentMigratorConsole())\n        .BuildServiceProvider(false);\n}\n')),Object(a.b)("p",null,"This checks to see if the Lastest migration has been applied and, if not, apply it."),Object(a.b)("p",null,'Each migration will be within the Migrations project, and has the name "Release_XXXX.cs" Where XXXX is the release number'),Object(a.b)("h2",{id:"migration-structure"},"Migration Structure"),Object(a.b)("p",null,"Each migration has two methods. First is the Up() method, and the second is the Down() method."),Object(a.b)("h3",{id:"up"},"Up()"),Object(a.b)("p",null,"Up occurs when migrating forward from one version to another. The general order of operations is:"),Object(a.b)("ol",null,Object(a.b)("li",{parentName:"ol"},"Create any new tables"),Object(a.b)("li",{parentName:"ol"},"Insert any new data"),Object(a.b)("li",{parentName:"ol"},"Perform any nescessary scripts")),Object(a.b)("h4",{id:"example"},"Example"),Object(a.b)("pre",null,Object(a.b)("code",Object(r.a)({parentName:"pre"},{}),'public override void Up() \n{\n    Create.Table("Demo")\n        .WithId("DemoId")\n        .WithColumn("DemoData").AsString(255).NotNullable()\n        .WithBaseModel();\n\n    Insert.IntoTable("Demo")\n        .Row(new \n        {\n            DemoData = "Demo"\n        });\n}\n')),Object(a.b)("h3",{id:"down"},"Down()"),Object(a.b)("p",null,"Down occurs when migrating back, to one version from another. The Down method must undo everything that was done in the Up method."),Object(a.b)("ol",null,Object(a.b)("li",{parentName:"ol"},"Revert any script changes"),Object(a.b)("li",{parentName:"ol"},"Remove any new data"),Object(a.b)("li",{parentName:"ol"},"Delete any new tables")),Object(a.b)("h4",{id:"example-1"},"Example"),Object(a.b)("pre",null,Object(a.b)("code",Object(r.a)({parentName:"pre"},{}),'public override void Down() \n{\n    Delete.Table("Demo");\n}\n')))}p.isMDXComponent=!0}}]);