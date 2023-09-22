package example;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class ForEachTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(ForEachTest.class);

	@Test
	public void body() {
		driver.navigate().to("https://www.google.com");
		javascript.executeScript("arguments[0].click();", driver.findElement(By.xpath(".//button[@id='L2AGLb']")));
		search("jwst");
		sleep(2);
	}
	
	private void search(String text) {
		driver.findElement(By.xpath(".//textarea[@name='q']")).sendKeys(text);
		javascript.executeScript("arguments[0].click();", driver.findElement(By.xpath(".//input[@name='btnK']")));
		for (var result: driver.findElements(By.xpath(".//h3"))) {
			logger.info(result.getText());
		}
	}
	
}
