pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        timestamps()
    }

    parameters {
        gitParameter(
            name: 'RELEASE_TAG',
            type: 'PT_TAG',
            defaultValue: '',
            description: 'Select the release tag to deploy',
            tagFilter: 'v*',
            sortMode: 'DESCENDING_SMART',
            selectedValue: 'NONE',
            quickFilterEnabled: true
        )
    }

    stages {
        stage('Validate selection') {
            steps {
                script {
                    if (!params.RELEASE_TAG?.trim()) {
                        error('Select a release tag using Build with Parameters.')
                    }

                    currentBuild.displayName =
                        "#${env.BUILD_NUMBER} | ${params.RELEASE_TAG}"
                }
            }
        }

        stage('Checkout release tag') {
            steps {
                deleteDir()

                checkout scmGit(
                    branches: [[
                        name: "refs/tags/${params.RELEASE_TAG}"
                    ]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/lightofvictory/cakeshopService',
                        credentialsId: 'github-cake-service',
                        refspec: '+refs/tags/*:refs/tags/*'
                    ]]
                )

                sh 'git log -1 --oneline'
            }
        }

        stage('Build') {
            steps {
                // Example for a Node/React project:
                sh 'npm ci'
                sh 'npm run build'
            }
        }

        stage('Deploy') {
            steps {
                // Replace with your existing deployment command.
                sh './deploy.sh'
            }
        }
    }
}
