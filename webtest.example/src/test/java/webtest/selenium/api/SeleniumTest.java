package webtest.selenium.api;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.Duration;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.FluentWait;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(SeleniumTest.class);
	private static int screenshotIndex = 0;
	protected static  WebDriver driver;
	protected static Actions actions;
	protected static JavascriptExecutor javascript;
	protected static FluentWait<WebDriver> wait;
	protected static TakesScreenshot screenshot;
	
	@BeforeAll
	public static void startup() {
		var chromeDriverLocation = System.getProperty("webdriver.chrome.driver");
		if (chromeDriverLocation == null) {
			chromeDriverLocation = "c:/Programs/chromedriver/chromedriver.exe";
			System.setProperty("webdriver.chrome.driver", chromeDriverLocation);
		}
		logger.info("Using chromedriver: "+chromeDriverLocation);
		driver = new ChromeDriver();
		javascript = (JavascriptExecutor)driver;
	    actions = new Actions(driver);
	    driver.manage().window().maximize();
		logger.info("Chrome is opened.");
		wait = new FluentWait<>(driver);
		wait.pollingEvery(Duration.ofSeconds(1));
		screenshot =(TakesScreenshot)driver;
	}
	
	@AfterAll
	public static void shutdown() {
    	driver.quit();
		logger.info("Chrome is closed.");
	}
	
	public static String capture() {
		var image = screenshot.getScreenshotAs(OutputType.BYTES);
		try {
			new File("output").mkdirs();
			var fileName = "screenshot"+(++screenshotIndex)+".png";
			var filePath = "output/"+fileName;
			var stream = new FileOutputStream(filePath);
			try {
				stream.write(image);
				stream.flush();
				logger.info("Captured: "+filePath);
				return fileName;
			} finally {
				stream.close();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	protected void sleep(int seconds) {

		try {
			Thread.sleep(seconds*1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
