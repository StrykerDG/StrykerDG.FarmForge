(window.webpackJsonp=window.webpackJsonp||[]).push([[12],{137:function(e,t,n){"use strict";n.r(t),t.default=n.p+"assets/images/Local_Individual-4580f82733829057da6f384643638124.PNG"},138:function(e,t,n){"use strict";n.r(t),t.default=n.p+"assets/images/Local_Api-e3e07ae8c3755ffae5e9e44e12dc2b4b.PNG"},139:function(e,t,n){"use strict";n.r(t),t.default=n.p+"assets/images/External_Api-ad00ee53ca156df88a5d785757a0e8d3.PNG"},140:function(e,t,n){"use strict";n.r(t),t.default=n.p+"assets/images/External_Interconnected-043ef38803e661643d0f9746c9fc5c76.PNG"},67:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return i})),n.d(t,"metadata",(function(){return c})),n.d(t,"rightToc",(function(){return s})),n.d(t,"default",(function(){return d}));var a=n(2),o=n(6),r=(n(0),n(99)),i={id:"dev_introduction",title:"Introduction",sidebar_label:"Introduction"},c={unversionedId:"development/dev_introduction",id:"development/dev_introduction",isDocsHomePage:!1,title:"Introduction",description:"FarmForge is 100% open source and can be used however you see fit. If you would",source:"@site/docs\\development\\introduction.md",slug:"/development/dev_introduction",permalink:"/docs/development/dev_introduction",editUrl:"https://github.com/facebook/docusaurus/edit/master/website/docs/development/introduction.md",version:"current",sidebar_label:"Introduction",sidebar:"someSidebar",previous:{title:"Contributing",permalink:"/docs/support/contributing"},next:{title:"Devices",permalink:"/docs/development/devices"}},s=[{value:"System Architecture",id:"system-architecture",children:[{value:"Local - Individual Devices",id:"local---individual-devices",children:[]},{value:"Local - Devices and API",id:"local---devices-and-api",children:[]},{value:"External - Devices and API",id:"external---devices-and-api",children:[]},{value:"External - Interconnected Systems",id:"external---interconnected-systems",children:[]}]},{value:"System Components",id:"system-components",children:[{value:"Devices",id:"devices",children:[]},{value:"Client (Web / Mobile)",id:"client-web--mobile",children:[]},{value:"Local API",id:"local-api",children:[]},{value:"External API",id:"external-api",children:[]},{value:"Actors",id:"actors",children:[]},{value:"Data Model",id:"data-model",children:[]},{value:"Migrations",id:"migrations",children:[]},{value:"IoT Hub",id:"iot-hub",children:[]}]}],l={rightToc:s};function d(e){var t=e.components,i=Object(o.a)(e,["components"]);return Object(r.b)("wrapper",Object(a.a)({},l,i,{components:t,mdxType:"MDXLayout"}),Object(r.b)("p",null,"FarmForge is 100% open source and can be used however you see fit. If you would\nlike to contribute to the project, or just want to know more about how the\nsystem works, you're in the right place!"),Object(r.b)("p",null,"The following sections contain detailed information about how various portions\nof the FarmForge software work. "),Object(r.b)("h2",{id:"system-architecture"},"System Architecture"),Object(r.b)("p",null,"FarmForge is designed so that it can be used on low cost hardware. There is also an emphasis on being able to run locally without external depencies, due to the\nfact that a lot of rurual areas still lack access to high speed internet. "),Object(r.b)("p",null,"FarmForge is architechted so that it can be utilized in the following ways:"),Object(r.b)("h3",{id:"local---individual-devices"},"Local - Individual Devices"),Object(r.b)("p",null,"This is the smallest, most simple configuration you can have. This is probably sufficient for a small garden or hobbyist wanting to connect a sensor to one or two of their plants. No data is saved or preserved in this configuration."),Object(r.b)("p",null,Object(r.b)("img",{alt:"Diagram",src:n(137).default})),Object(r.b)("h3",{id:"local---devices-and-api"},"Local - Devices and API"),Object(r.b)("p",null,"This is the next stage up in configuration, and is slightly more complex. Here, a central FarmForge server is running on your local network that hosts a web client, api, and database. The primary interactions take place between your personal device and the web client, but you can still access the FarmForge devices directly should you desire. Since a database is present, historical data can be / is saved."),Object(r.b)("p",null,Object(r.b)("img",{alt:"Diagram",src:n(138).default})),Object(r.b)("h3",{id:"external---devices-and-api"},"External - Devices and API"),Object(r.b)("p",null,"This configuration is the same as the previous (Local - Devices and API); however, it has an additional cloud-hosted API that connects to and interacts with the local API through an IoT hub. This allows us to reach our local devices from anywhere we have internet access."),Object(r.b)("p",null,Object(r.b)("img",{alt:"Diagram",src:n(139).default})),Object(r.b)("h3",{id:"external---interconnected-systems"},"External - Interconnected Systems"),Object(r.b)("p",null,"The Interconnected system has the same architecture as the External - Devices and API. There is just one additional link between the user's cloud-hosted API and a central FarmForge api and database. This allows FarmForge users to view device data from all other connected FarmForge systems to help them grow crops more effectively, if they desire to do so."),Object(r.b)("p",null,Object(r.b)("em",{parentName:"p"},"NOTE")," - When choosing to connect your system to the central FarmForge system, you will have the ability to choose what, if anything, gets shared."),Object(r.b)("p",null,Object(r.b)("img",{alt:"Diagram",src:n(140).default})),Object(r.b)("h2",{id:"system-components"},"System Components"),Object(r.b)("p",null,"There are several components that make up the FarmForge system."),Object(r.b)("h3",{id:"devices"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/devices"}),"Devices")),Object(r.b)("p",null,"Devices are the actual IoT components that are utilized within your garden,\ngreenhouse, or farm. They can be as simple as complex as desired, from a single\nsensor all the way up to multiple sensors, guages, motors, touch screens, and\nmore. Devices can be used on their own, or connect to a central API, from which\na web app can be utilized to easily control and monitor your operation."),Object(r.b)("h3",{id:"client-web--mobile"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/client"}),"Client (Web / Mobile)")),Object(r.b)("p",null,"The FarmForge client is accessible through both your local and external networks when utilizing the associated API. The client allows easy access to your devices,\nin addition to farm management functionalities."),Object(r.b)("h3",{id:"local-api"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/api"}),"Local API")),Object(r.b)("p",null,"The FarmForge API acts as the central hub of your local FarmForge installation.\nAll devices can / will connect to the API and send their telemetry for storage\nin a database. Utilizing the API also enables use of a web app to view various\nreport data, device controls, and receive text notifications."),Object(r.b)("p",null,"If desired, it can be conected to an external facing API in a cloud provider so your FarmForge network can be accessed anywhere you have an internet connection."),Object(r.b)("h3",{id:"external-api"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/ext_api"}),"External API")),Object(r.b)("p",null,"The external API is just an externally facing gateway that calls methods on your\nlocal API through the use of an IoT Hub. When outside of your local network, the\nmobile app utilizes this external API."),Object(r.b)("h3",{id:"actors"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/actors"}),"Actors")),Object(r.b)("h3",{id:"data-model"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/data_model"}),"Data Model")),Object(r.b)("h3",{id:"migrations"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/migrations"}),"Migrations")),Object(r.b)("h3",{id:"iot-hub"},Object(r.b)("a",Object(a.a)({parentName:"h3"},{href:"/docs/development/iot_hub"}),"IoT Hub")),Object(r.b)("p",null,"The IoT hub is what allows your local FarmForge network to be accessed from the\noutside world. The local API connects to the Hub as a client while the External\nAPI connects as a server. This allows communication from anywhere without having\nto open your network."))}d.isMDXComponent=!0},99:function(e,t,n){"use strict";n.d(t,"a",(function(){return u})),n.d(t,"b",(function(){return p}));var a=n(0),o=n.n(a);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,a,o=function(e,t){if(null==e)return{};var n,a,o={},r=Object.keys(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var l=o.a.createContext({}),d=function(e){var t=o.a.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},u=function(e){var t=d(e.components);return o.a.createElement(l.Provider,{value:t},e.children)},b={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},h=o.a.forwardRef((function(e,t){var n=e.components,a=e.mdxType,r=e.originalType,i=e.parentName,l=s(e,["components","mdxType","originalType","parentName"]),u=d(n),h=a,p=u["".concat(i,".").concat(h)]||u[h]||b[h]||r;return n?o.a.createElement(p,c(c({ref:t},l),{},{components:n})):o.a.createElement(p,c({ref:t},l))}));function p(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var r=n.length,i=new Array(r);i[0]=h;var c={};for(var s in t)hasOwnProperty.call(t,s)&&(c[s]=t[s]);c.originalType=e,c.mdxType="string"==typeof e?e:a,i[1]=c;for(var l=2;l<r;l++)i[l]=n[l];return o.a.createElement.apply(null,i)}return o.a.createElement.apply(null,n)}h.displayName="MDXCreateElement"}}]);