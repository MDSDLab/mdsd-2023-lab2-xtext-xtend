package example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class WizardTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(WizardTest.class);

	@Test
	public void body() {
		driver.navigate().to("https://www.w3schools.com/howto/howto_js_form_steps.asp");
		sleep(1);
		WebElement acceptCookies = null;
		var _elements1 = driver.findElements(By.xpath(".//div[@id='accept-choices']"));
		if (_elements1.size() == 1) {
			acceptCookies = _elements1.get(0);
		}
		if (acceptCookies != null) {
			acceptCookies.click();
		}
		while (driver.findElements(By.xpath(".//button[text()='Next']")).size() == 1) {
			var _page1 = new Name(driver);
			if (_page1.getFirstName() != null && _page1.getFirstName().isDisplayed()) {
				_page1.getFirstName().sendKeys("Agent");
				_page1.getLastName().sendKeys("Smith");
				assertEquals("Smith", _page1.getLastName().getAttribute("value"));
			}
			var _page2 = new ContactInfo(driver);
			if (_page2.getEmail() != null && _page2.getEmail().isDisplayed()) {
				_page2.getEmail().sendKeys("smith@matrix.com");
				_page2.getPhone().sendKeys("5551234");
				assertTrue(_page2.getEmail().getAttribute("value").contains("smith"));
			}
			var _page3 = new Birthday(driver);
			if (_page3.getDay() != null && _page3.getDay().isDisplayed()) {
				_page3.getDay().sendKeys("01");
				_page3.getMonth().sendKeys("01");
				_page3.getYear().sendKeys("2000");
			}
			var _page4 = new ContactInfo(driver);
			if (_page4.getPhone() != null && _page4.getPhone().isDisplayed()) {
				_page4.getPhone().clear();
				_page4.getPhone().sendKeys("5554321");
			}
			var _page5 = new LoginInfo(driver);
			if (_page5.getUsername() != null && _page5.getUsername().isDisplayed()) {
				_page5.getUsername().sendKeys("smith");
				_page5.getPassword().sendKeys("secret");
			}
			sleep(1);
			javascript.executeScript("arguments[0].click();", driver.findElement(By.xpath(".//button[text()='Next']")));
		}
	}
	
	
	private static class Name {
		private WebDriver driver;
		
		public Name(WebDriver driver) {
			this.driver = driver;
		}

		public WebElement getFirstName() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='First name...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getLastName() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='Last name...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
	}
	private static class ContactInfo {
		private WebDriver driver;
		
		public ContactInfo(WebDriver driver) {
			this.driver = driver;
		}

		public WebElement getEmail() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='E-mail...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getPhone() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='Phone...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
	}
	private static class Birthday {
		private WebDriver driver;
		
		public Birthday(WebDriver driver) {
			this.driver = driver;
		}

		public WebElement getDay() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='dd']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getMonth() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='mm']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getYear() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='yyyy']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
	}
	private static class LoginInfo {
		private WebDriver driver;
		
		public LoginInfo(WebDriver driver) {
			this.driver = driver;
		}
		
		public WebElement getUsername() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='Username...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getPassword() {
			var elements = driver.findElements(By.xpath(".//input[@placeholder='Password...']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
	}
}
