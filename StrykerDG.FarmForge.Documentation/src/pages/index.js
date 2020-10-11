import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';

const features = [
  {
    title: 'Affordable',
    imageUrl: 'img/undraw_docusaurus_mountain.svg',
    description: (
      <>
        The FarmForge software is free and open source, the API and client are 
        able to run on a Raspberry Pi, and the IoT devices can be built on an 
        Arduino.
      </>
    ),
  },
  {
    title: 'Community Driven',
    imageUrl: 'img/undraw_docusaurus_tree.svg',
    description: (
      <>
        FarmForge is designed to help hobbyists, gardners, and farmers keep track
        of their operations and simplify their work. We constantly implement
        feedback and requests from the community to make the software better.
      </>
    ),
  },
  {
    title: 'Local First',
    imageUrl: 'img/undraw_docusaurus_react.svg',
    description: (
      <>
        Not everyone has access to reliable, high speed internet,
        and FarmForge is developed with that in mind. As long as you have a local
        network setup, you can use the software.
      </>
    ),
  },
];

function Feature({imageUrl, title, description}) {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className={clsx('col col--4', styles.feature)}>
      {imgUrl && (
        <div className="text--center">
          <img className={styles.featureImage} src={imgUrl} alt={title} />
        </div>
      )}
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}

function Home() {
  const context = useDocusaurusContext();
  const {siteConfig = {}} = context;
  return (
    <Layout
      title={siteConfig.title}
      description="Description will go into a meta tag in <head />">
      <header className={clsx('hero hero--primary', styles.heroBanner)}>
        <div className="container">
          <h1 className="hero__title">{siteConfig.title}</h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className={clsx(
                'button button--outline button--secondary button--lg',
                styles.getStarted,
              )}
              to={useBaseUrl('docs/farmforge/introduction')}>
              Get Started
            </Link>
          </div>
        </div>
      </header>
      <main>
        {features && features.length > 0 && (
          <section className={styles.features}>
            <div className="container">
              <div className="row">
                {features.map((props, idx) => (
                  <Feature key={idx} {...props} />
                ))}
              </div>
            </div>
          </section>
        )}
      </main>
    </Layout>
  );
}

export default Home;
