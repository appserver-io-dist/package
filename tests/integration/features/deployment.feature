# features/deployment.feature
Feature: deployment
  In order to allow for file based webapp deployment
  As an appserver.io user
  The appserver needs to be able to properly react on deployment flag files
  
Scenario: deploy using the .dodeploy flag
  Given the deploy dir contains a file "example.phar"
  And there is a running service "appserver-watcher"
  When the deploy dir contains a file "example.phar.dodeploy"
  And I wait for appserver restart
  Then the deploy dir contains a file "example.phar.deployed"
  And the webapps dir contains a webapp "example"