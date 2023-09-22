package webtest.generator

class WebTestProjectGenerator {
	def generateHelloWorld() {
		'''
		webtest example.HelloWorld
		
		test SayHelloTest
			print "Hello World!"
		end
		'''
	}
	
	def generateLogback() {
		'''
		<?xml version="1.0" encoding="UTF-8" ?>
		<configuration>
		  <import class="ch.qos.logback.classic.encoder.PatternLayoutEncoder"/>
		  <import class="ch.qos.logback.core.ConsoleAppender"/>
		
		  <appender name="STDOUT" class="ConsoleAppender">
		    <encoder class="PatternLayoutEncoder">
		      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} -%kvp- %msg%n</pattern>
		    </encoder>
		  </appender>
		
		  <root level="info">
		    <appender-ref ref="STDOUT"/>
		  </root>
		</configuration>
		'''
	}
	
	def generateLogbackTest() {
		'''
		<?xml version="1.0" encoding="UTF-8" ?>
		<configuration>
		  <import class="ch.qos.logback.classic.encoder.PatternLayoutEncoder"/>
		  <import class="ch.qos.logback.core.ConsoleAppender"/>
		
		  <appender name="STDOUT" class="ConsoleAppender">
		    <encoder class="PatternLayoutEncoder">
		      <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} -%kvp- %msg%n</pattern>
		    </encoder>
		  </appender>
		
		  <root level="info">
		    <appender-ref ref="STDOUT"/>
		  </root>
		</configuration>
		'''
	}

	
	def generatePomXml(String projectName) {
		'''
		<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		  <modelVersion>4.0.0</modelVersion>
		  <groupId>webtest</groupId>
		  <artifactId>«projectName»</artifactId>
		  <version>0.0.1-SNAPSHOT</version>
		
		  <properties>
		    <version.java>17</version.java>
		    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		    <version.maven.compiler>3.11.0</version.maven.compiler>
		    <version.maven.surefire>3.1.2</version.maven.surefire>
		    <version.selenium>4.11.0</version.selenium>
		    <version.junit>5.10.0</version.junit>
		    <version.slf4j>2.0.7</version.slf4j>
		    <version.logback>1.4.11</version.logback>
		  </properties>
		  
		  <dependencies>
			<dependency>
			    <groupId>org.slf4j</groupId>
			    <artifactId>slf4j-api</artifactId>
			    <version>${version.slf4j}</version>
			</dependency>
			<dependency>
			    <groupId>ch.qos.logback</groupId>
			    <artifactId>logback-classic</artifactId>
			    <version>${version.logback}</version>
			</dependency>
		    <dependency>
		      <groupId>org.seleniumhq.selenium</groupId>
		      <artifactId>selenium-chrome-driver</artifactId>
		      <version>${version.selenium}</version>
		    </dependency>
		    <dependency>
		      <groupId>org.seleniumhq.selenium</groupId>
		      <artifactId>selenium-java</artifactId>
		      <version>${version.selenium}</version>
		    </dependency>
		    <dependency>
		      <groupId>org.junit.jupiter</groupId>
		      <artifactId>junit-jupiter</artifactId>
		      <version>${version.junit}</version>
		      <scope>test</scope>
		    </dependency>
		  </dependencies>
		  
		  <build>
		    <finalName>${project.artifactId}</finalName>
		    <plugins>
		      <plugin>
		        <groupId>org.apache.maven.plugins</groupId>
		        <artifactId>maven-compiler-plugin</artifactId>
		        <version>${version.maven.compiler}</version>
		        <configuration>
		            <release>${version.java}</release>
		        </configuration>
		      </plugin>
		      <plugin>
		        <artifactId>maven-surefire-plugin</artifactId>
		        <version>${version.maven.surefire}</version>
		        <configuration>
		          <systemPropertyVariables>
		            <webdriver.chrome.driver>c:/Programs/chromedriver/chromedriver.exe</webdriver.chrome.driver>
		          </systemPropertyVariables>
		        </configuration>
		      </plugin>
		    </plugins>
		  </build>
		  
		</project>
		'''
	}

	def generateClasspath() {
		'''
		<?xml version="1.0" encoding="UTF-8"?>
		<classpath>
			<classpathentry kind="src" output="target/classes" path="src/main/java">
				<attributes>
					<attribute name="optional" value="true"/>
					<attribute name="maven.pomderived" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="src" output="target/test-classes" path="src-gen/test/java">
				<attributes>
					<attribute name="test" value="true"/>
					<attribute name="optional" value="true"/>
					<attribute name="maven.pomderived" value="true"/>
				</attributes>
		    </classpathentry>
			<classpathentry excluding="**" kind="src" output="target/classes" path="src/main/resources">
				<attributes>
					<attribute name="maven.pomderived" value="true"/>
					<attribute name="optional" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="src" output="target/test-classes" path="src/test/java">
				<attributes>
					<attribute name="test" value="true"/>
					<attribute name="optional" value="true"/>
					<attribute name="maven.pomderived" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry excluding="**" kind="src" output="target/test-classes" path="src/test/resources">
				<attributes>
					<attribute name="test" value="true"/>
					<attribute name="maven.pomderived" value="true"/>
					<attribute name="optional" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-17">
				<attributes>
					<attribute name="module" value="true"/>
					<attribute name="maven.pomderived" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="con" path="org.eclipse.m2e.MAVEN2_CLASSPATH_CONTAINER">
				<attributes>
					<attribute name="maven.pomderived" value="true"/>
				</attributes>
			</classpathentry>
			<classpathentry kind="output" path="target/classes"/>
		</classpath>
		'''
	}

	def generateGitignore() {
		'''
		target
		output
		'''
	}
	

}