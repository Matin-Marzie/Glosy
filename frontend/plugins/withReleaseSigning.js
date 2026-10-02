const { withAppBuildGradle } = require('expo/config-plugins');

// Signs release builds with the Play upload key.
// Credentials live in ~/.gradle/gradle.properties, never in the repo.
const releaseSigningConfig = `
        release {
            storeFile file(findProperty('GLOSY_RELEASE_STORE_FILE') ?: 'missing-release.jks')
            storePassword findProperty('GLOSY_RELEASE_STORE_PASSWORD')
            keyAlias findProperty('GLOSY_RELEASE_KEY_ALIAS')
            keyPassword findProperty('GLOSY_RELEASE_KEY_PASSWORD')
        }`;

module.exports = function withReleaseSigning(config) {
  return withAppBuildGradle(config, (config) => {
    let gradle = config.modResults.contents;
    if (gradle.includes('GLOSY_RELEASE_STORE_FILE')) return config;

    // Add a release signing config next to the default debug one.
    gradle = gradle.replace(
      /(signingConfigs\s*\{\s*debug\s*\{[^}]*\})/,
      `$1${releaseSigningConfig}`
    );
    // Point the release build type at it instead of the debug key.
    gradle = gradle.replace(
      /(buildTypes\s*\{[\s\S]*?release\s*\{[\s\S]*?)signingConfig signingConfigs\.debug/,
      '$1signingConfig signingConfigs.release'
    );

    config.modResults.contents = gradle;
    return config;
  });
};
