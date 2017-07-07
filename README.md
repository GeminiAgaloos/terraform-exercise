This is an simple exercise used to filter interview candidates by assessing your approach to development and use of
infrastructure as code tooling. This has been tested using Terraform v0.9.11 we advise you use 
this version as we will test your code with the same.

Here we have a Terraform script building a simple VPC network with public and private subnets, for now we have just  
one instance in the public zone running the web server Nginx in it's default configuration, serving up the default 
welcome page. We want this to be extended, you're are tasked with making the alterations detailed below, after 
completing each stage a test to show the things are still working would be to run the following command and expect to 
see the Nginx welcome page HTML.

    terraform output nginx_domain | xargs curl
    
Complete exercises 1-3, it is advisable to commit often, please don't submit just one commit. You are not expected to 
complete 4a or 4b as these tasks are more involved and we value your time, however if you have time to and would like to 
then please do implement just one of them. Alternatively you may begin to implement one and not complete it, you won't 
be marked down for this, leave TODO comments where appropriate and/or document how you would implement the task had you 
the time in a text file called notes.txt in the repository root.

1. Since Amazon have released a region in the UK, we want to be able to run the same stack closer to our customers in 
England. Create a new tfvars file name london.tfvars populate it with the required variables to build the same stack in 
the eu-west-2 region. Note that London currently has only two availability zones so that will need to be taken into 
consideration we still want to run a stack in Ireland that takes advantage of all 3 AZs in that region. Feel free to 
modify the existing code as much as possible in order to do this we'd like to see a solution that has as much reuse as 
possible with little or no duplication, and don't feel your are confined to the same variable definitions these can be 
changed. As for a CIDR range for the VPC use whatever you feel like providing your compliant with RFC-1918

2. The Nginx instance we have had been running for a long while the disk became full over the weekend and we had an 
outage. We've decided that we need a solution that is more resilient than just a single instance, please implement a
solution that you'd be confident would continue to run in the event one instance goes down. 

3. We are looking to improve the security of our network we've decided we need a bastion server to avoid logging on 
directly to our servers. Add a bastion server, the bastion should be the only route to SSH onto any server in the 
entire VPC.

4. a) We have decided to use the Java framework Spring Boot to build features for our website. Deploy the following sample 
application into the VPC, reconfigure Nginx as a reverse proxy to the Java app. Provide a modification to the Terraform 
output/curl command to get the hello world text that the application serves. 
https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples/spring-boot-sample-tomcat
<br> b) Follow the instructions in a) but instead deploy the following application, with an alteration to use an Amazon 
RDS managed database rather than the default H2 in memory database. 
https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples/spring-boot-sample-data-jpa


