module.exports = {
  branches: ['main'],
  tagFormat: 'v${version}',
  plugins: [
    ['@semantic-release/commit-analyzer', {
      preset: 'angular',
      releaseRules: [
        {type: 'docs', release: 'patch'},
        {type: 'refactor', release: 'patch'},
        {type: 'style', release: 'patch'},
        {type: 'chore', release: 'patch'},
        {type: 'perf', release: 'patch'},
        {type: 'test', release: 'patch'}
      ]
    }],
    '@semantic-release/release-notes-generator',
    ['@semantic-release/npm', {
      npmPublish: false
    }],
    ['@semantic-release/github', {
      assets: [
        {path: 'target/*.war', label: 'WAR file'},
        {path: 'target/*.jar', label: 'JAR file'}
      ],
      successComment: false,
      failComment: false
    }],
    ['@semantic-release/git', {
      assets: ['package.json', 'pom.xml'],
      message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}'
    }],
  ],
};
