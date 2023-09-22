package example;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webtest.selenium.api.SeleniumTest;

public class JavaScriptTest extends SeleniumTest {
	private static Logger logger = LoggerFactory.getLogger(DialogTest.class);

	@Test
	public void largeModalTest() {
		driver.navigate().to("https://getbootstrap.com/docs/4.0/components/modal/");
		var _page1 = new Bootstrap(driver);
		HighlightAndClick(_page1.getLargeModal());
		var _page2 = new ModalDialog(_page1.getLargeDialog());
		HighlightAndClick(_page2.getClose());
	}
	
	private void HighlightAndClick(WebElement element) {
		javascript.executeScript("arguments[0].style.outline = 'red solid 4px'; arguments[0].style.outlineOffset = '-4px'; arguments[0].scrollIntoView({ block: 'center', inline: 'center' });", element);
		sleep(1);
		javascript.executeScript("arguments[0].style.outline = ''; arguments[0].style.outlineOffset = '';", element);
		element.click();
	}
	
	private static class Bootstrap {
		private SearchContext context;
		
		public Bootstrap(SearchContext context) {
			this.context = context;
		}

		public WebElement getLargeModal() {
			var elements = context.findElements(By.xpath(".//button[text()='Large modal']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}

		public WebElement getLargeDialog() {
			var elements = context.findElements(By.xpath(".//div[@aria-labelledby='myLargeModalLabel']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
		
	}
	private static class ModalDialog {
		private SearchContext context;
		
		public ModalDialog(SearchContext context) {
			this.context = context;
		}

		public WebElement getClose() {
			var elements = context.findElements(By.xpath(".//button[@aria-label='Close']"));
			if (elements.size() == 1) return elements.get(0);
			else return null;
		}
		
	}
}
