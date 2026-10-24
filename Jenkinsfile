pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        timestamps()
    }

   parameters {
    string(
        name: 'RELEASE_TAG',
        defaultValue: '',
        description: 'Enter a Git tag, e.g. release/v1.0.1',
        trim: true
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
        sh 'npm ci --legacy-peer-deps'
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
