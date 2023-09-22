package example;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class ManualTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(ManualTest.class);
	private PrintWriter _writer;
	
	@Test
	public void LetMeGoogleThatForYou() {
		try {
			new File("output").mkdirs();
			_writer = new PrintWriter("output/LetMeGoogleThatForYou.html");
			try {
				_writer.print("<h1>Google keresés</h1>");
				_writer.println();
				_writer.print("<p>Nyissuk meg a <b>https://www.google.com</b> oldalt:</p>");
				_writer.println();
				driver.navigate().to("https://www.google.com");
				_writer.print("<img src='");
				_writer.print(capture());
				_writer.println("'/>");
				_writer.print("<p>Fogadjuk el a cookie-kat:</p>");
				_writer.println();
				Click(driver.findElement(By.xpath(".//button[@id='L2AGLb']")));
				String searchText = "jwst";
				_writer.print("<p>Írjuk be a keresőbe a <b>");
				_writer.print(searchText);
				_writer.print("</b> szöveget:</p>");
				_writer.println();
				Fill(driver.findElement(By.xpath(".//textarea[@name='q']")), searchText);
				_writer.print("<p>Végül kattintsunk a <b>Google-keresés</b> gombra:</p>");
				_writer.println();
				Click(driver.findElement(By.xpath(".//input[@name='btnK']")));
				sleep(2);
				_writer.print("<p>És láthatjuk a keresési találatokat:</p>");
				_writer.println();
				_writer.print("<img src='");
				_writer.print(capture());
				_writer.println("'/>");
			} finally {
				_writer.close();
				_writer = null;
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}				
	}
	
	
	private void Click(WebElement element) {
		javascript.executeScript("arguments[0].style.outline = 'red solid 4px'; arguments[0].style.outlineOffset = '-4px'; arguments[0].scrollIntoView({ block: 'center', inline: 'center' });", element);
		sleep(1);
		_writer.print("<img src='");
		_writer.print(capture());
		_writer.println("'/>");
		javascript.executeScript("arguments[0].style.outline = ''; arguments[0].style.outlineOffset = '';", element);
		javascript.executeScript("arguments[0].click();", element);
	}
	
	private void Fill(WebElement element, String text) {
		element.sendKeys(text);
		javascript.executeScript("arguments[0].style.outline = 'red solid 4px'; arguments[0].style.outlineOffset = '-4px'; arguments[0].scrollIntoView({ block: 'center', inline: 'center' });", element);
		sleep(1);
		_writer.print("<img src='");
		_writer.print(capture());
		_writer.println("'/>");
		javascript.executeScript("arguments[0].style.outline = ''; arguments[0].style.outlineOffset = '';", element);
	}
	
}
