module.exports = {
  title: 'FarmForge',
  tagline: 'The tagline of my site',
  url: 'https://strykerdg.github.io',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  favicon: 'img/favicon.ico',
  organizationName: 'StrykerDG', 
  projectName: 'StrykerDG.FarmForge',
  themeConfig: {
    navbar: {
      title: 'FarmForge',
      logo: {
        alt: 'My Site Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          to: 'docs/farmforge/introduction',
          activeBasePath: 'docs/farmforge',
          label: 'Docs',
          position: 'left',
        },
        {to: 'blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/StrykerDG/StrykerDG.FarmForge',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Introduction',
              to: 'docs/farmforge/introduction',
            },
            {
              label: 'Installation',
              to: 'docs/getting_started/installation',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/farmforge',
            },
            {
              label: 'Discord',
              href: 'https://discord.gg/rfyhhTE',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/StrykerDG',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: 'blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/StrykerDG/StrykerDG.FarmForge',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} FarmForge, Inc. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/blog/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
