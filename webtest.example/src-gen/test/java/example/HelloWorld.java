package example;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class HelloWorld extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(HelloWorld.class);

	@Test
	public void SayHelloTest() {
		logger.info("Hello World!");
	}
	
}
