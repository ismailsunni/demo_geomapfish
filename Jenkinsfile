#!groovy
@Library('c2c-pipeline-library')
import static com.camptocamp.utils.*

final IMAGES = ['wsgi', 'mapserver', 'print']
final IMAGES_BASE_NAME = 'camptocamp/demo-geomapfish'

if (env.BRANCH_NAME == 'master') {
    tag = 'latest'
} else {
    tag = env.BRANCH_NAME
}

env.DOCKER_TAG = tag

dockerBuild {
    stage('Build') {
        checkout scm
        sh 'docker pull camptocamp/geomapfish_build:jenkins'
        sh './docker-run make -j2 build'
    }
    stage('Test') {
        checkout scm
        sh 'docker-compose up'
        sh 'curl https://localhost:8480/wsgi/check_collector?'
        sh 'curl https://localhost:8480/wsgi/check_collector?type=all'
    }
    stage('Publish') {
         withCredentials([[
            $class: 'UsernamePasswordMultiBinding',
            credentialsId: 'dockerhub',
            usernameVariable: 'USERNAME',
            passwordVariable: 'PASSWORD'
        ]]) {
            sh 'docker login -u "$USERNAME" -p "$PASSWORD"'
            for (String image : IMAGES) {
                docker.image("${IMAGES_BASE_NAME}_${image}:${tag}").push()
            }
            sh 'rm -rf ~/.docker*'
         }
    }
}