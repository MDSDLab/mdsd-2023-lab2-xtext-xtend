package example;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class GoogleTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(GoogleTest.class);

	@Test
	public void body() {
		driver.navigate().to("https://www.google.com");
		WebElement acceptCookies = null;
		var _elements1 = driver.findElements(By.xpath(".//button[@id='L2AGLb']"));
		if (_elements1.size() == 1) {
			acceptCookies = _elements1.get(0);
		}
		if (acceptCookies != null) {
			javascript.executeScript("arguments[0].click();", acceptCookies);
		}
		search("jwst");
		sleep(2);
	}
	
	private void search(String text) {
		driver.findElement(By.xpath(".//textarea[@name='q']")).sendKeys(text);
		javascript.executeScript("arguments[0].click();", driver.findElement(By.xpath(".//input[@name='btnK']")));
	}
	
}
