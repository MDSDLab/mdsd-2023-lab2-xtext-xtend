package example;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Duration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class TestParamsTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(TestParamsTest.class);

	@ParameterizedTest
	@CsvSource({"2,3,6", "4,7,28", "23,6,138"})
	public void MultiplicationTest(String left, String right, String result) {
		driver.navigate().to("https://www.calculatorsoup.com/calculators/math/basic.php");
		var page = new Calculator(driver);
		wait.withTimeout(Duration.ofSeconds(10));
		wait.until(wd -> page.getDisplay() != null);
		logger.info("Page opened");
		page.multiply(left, right);
		assertEquals(result.toString(), page.getDisplay().getAttribute("value"));
		capture();
	}
	
	@Test
	public void body() {
		int timeout = 10;
		driver.navigate().to("https://www.calculatorsoup.com/calculators/math/basic.php");
		wait.withTimeout(Duration.ofSeconds(timeout));
		wait.until(wd -> driver.findElements(By.xpath(".//input[@aria-label='number display']")).size() > 0);
		driver.findElement(By.xpath(".//button[text()='AC']")).click();
		driver.findElement(By.xpath(".//input[@aria-label='number display']")).sendKeys("23");
		driver.findElement(By.xpath(".//button[text()='×']")).click();
		driver.findElement(By.xpath(".//input[@aria-label='number display']")).sendKeys("6");
		driver.findElement(By.xpath(".//button[text()='=']")).click();
		assertEquals("138".toString(), driver.findElement(By.xpath(".//input[@aria-label='number display']")).getAttribute("value"));
		capture();
	}
	
	
	private static class Calculator {
		private WebDriver driver;
		
		public Calculator(WebDriver driver) {
			this.driver = driver;
		}
		
		public void binaryOperation(String left, WebElement op, String right) {
			this.getClear().click();
			this.getDisplay().sendKeys(left);
			op.click();
			this.getDisplay().sendKeys(right);
			this.getCompute().click();
		}
		
		public void multiply(String left, String right) {
			this.binaryOperation(left, this.getMultiply(), right);
		}

		public WebDriver getDriver() {
			return driver;
		}

		public WebElement getDisplay() {
			var elements = driver.findElements(By.xpath(".//input[@aria-label='number display']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getClear() {
			var elements = driver.findElements(By.xpath(".//button[text()='AC']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getAdd() {
			var elements = driver.findElements(By.xpath(".//button[text()='+']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getSubtract() {
			var elements = driver.findElements(By.xpath(".//button[text()='-']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getMultiply() {
			var elements = driver.findElements(By.xpath(".//button[text()='×']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getDivide() {
			var elements = driver.findElements(By.xpath(".//button[text()='/']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getCompute() {
			var elements = driver.findElements(By.xpath(".//button[text()='=']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
	}

}
