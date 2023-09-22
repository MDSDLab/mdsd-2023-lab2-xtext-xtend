package example;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class BasePagesTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(BasePagesTest.class);

	@Test
	public void body() {
		driver.navigate().to("https://www.w3schools.com/howto/howto_js_form_steps.asp");
		sleep(1);
		driver.findElement(By.xpath(".//div[@id='accept-choices']")).click();
		var _page1 = new Name(driver);
		_page1.getFirstName().sendKeys("Agent");
		_page1.getLastName().sendKeys("Smith");
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page1.getNext());
		var _page2 = new ContactInfo(driver);
		_page2.getEmail().sendKeys("smith@matrix.com");
		_page2.getPhone().sendKeys("5551234");
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page2.getNext());
		var _page3 = new Birthday(driver);
		_page3.getDay().sendKeys("01");
		_page3.getMonth().sendKeys("01");
		_page3.getYear().sendKeys("2000");
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page3.getPrevious());
		var _page4 = new ContactInfo(driver);
		_page4.getPhone().clear();
		_page4.getPhone().sendKeys("5554321");
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page4.getNext());
		var _page5 = new Birthday(driver);
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page5.getNext());
		var _page6 = new LoginInfo(driver);
		_page6.getUsername().sendKeys("smith");
		_page6.getPassword().sendKeys("secret");
		sleep(1);
		javascript.executeScript("arguments[0].click();", _page6.getSubmit());
	}
	
	private static class WizardPage {
		protected WebDriver driver;

		public WizardPage(WebDriver driver) {
			this.driver = driver;
		}

		public WebElement getNext() {
			var elements = driver.findElements(By.xpath(".//button[text()='Next']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getPrevious() {
			var elements = driver.findElements(By.xpath(".//button[text()='Previous']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}		
	}
	
	private static class Name extends WizardPage {
		public Name(WebDriver driver) {
			super(driver);
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
	private static class ContactInfo extends WizardPage {
		public ContactInfo(WebDriver driver) {
			super(driver);
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
	private static class Birthday extends WizardPage {
		public Birthday(WebDriver driver) {
			super(driver);
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
	private static class LoginInfo extends WizardPage {
		public LoginInfo(WebDriver driver) {
			super(driver);
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

		public WebElement getSubmit() {
			var elements = driver.findElements(By.xpath(".//button[text()='Submit']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

	}
}
