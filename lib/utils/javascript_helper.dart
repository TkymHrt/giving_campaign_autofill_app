import 'dart:convert';

import '../models/user_info.dart';

class JavaScriptHelper {
  static String getAutoInputScript(UserInfo userInfo) {
    return '''
    function delay(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    }

    function getYearIndex(year) {
      return Math.max(2024 - year, 0);
    }

    function getMonthOrDayIndex(number) {
      return Math.max(number - 1, 0);
    }

    const arrowDownEvent = new KeyboardEvent("keydown", {
      key: "ArrowDown",
      keyCode: 40,
      bubbles: true,
      cancelable: true,
    });

    function setInputValue(element, value) {
      if (element) {
        const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
          window.HTMLInputElement.prototype,
          "value"
        ).set;

        nativeInputValueSetter.call(element, value);

        element.focus();
        element.dispatchEvent(new Event('input', { bubbles: true }));
        element.dispatchEvent(new Event('change', { bubbles: true }));
        element.blur();
      }
    }

    function setRadioValue(element) {
      if (element) {
        element.checked = false;

        const events = [
          new Event('input', { bubbles: true, cancelable: true }),
          new Event('change', { bubbles: true, cancelable: true }),
          new MouseEvent('click', { bubbles: true, cancelable: true }),
          new MouseEvent('mousedown', { bubbles: true, cancelable: true }),
          new MouseEvent('mouseup', { bubbles: true, cancelable: true })
        ];

        events.forEach(event => {
          element.dispatchEvent(event);
        });

        setTimeout(() => {
          element.dispatchEvent(new Event('input', { bubbles: true, cancelable: true }));
        }, 100);
      }
    }

    async function selectOption(inputElement, optionIndex) {
      if (inputElement) {
        inputElement.focus();
        inputElement.dispatchEvent(arrowDownEvent);
        await delay(500);
        const options = document.querySelectorAll(".rs__option");
        if (options.length > 0 && options[optionIndex]) {
          options[optionIndex].click();
        }
        inputElement.blur();
      }
    }

    async function autoInput() {
      try {
        const userInfo = ${json.encode(userInfo?.toJson())};
        Flutter.postMessage("自動入力を開始します...");
        console.log("Auto inputting user info:", userInfo);

        const form = document.querySelector('form');
        if (!form) {
          throw new Error('フォームが見つかりません');
        }

        const reactSelectInputs = document.querySelectorAll("#react-select-rs-input");
        if (reactSelectInputs.length > 0) {
          await selectOption(reactSelectInputs[0], getYearIndex(userInfo.birthYear));
          await delay(300);
          await selectOption(reactSelectInputs[1], getMonthOrDayIndex(userInfo.birthMonth));
          await delay(300);
          await selectOption(reactSelectInputs[2], getMonthOrDayIndex(userInfo.birthDay));
          await delay(300);
          await selectOption(reactSelectInputs[4], 5);
          await delay(300);
        }

        const inputSelectors = {
          lastName: 'input[name="lastName"]',
          firstName: 'input[name="firstName"]',
          kanaLastName: 'input[name="kanaLastName"]',
          kanaFirstName: 'input[name="kanaFirstName"]',
          email: 'input[name="email"]',
          tel: 'input[name="phoneNumber"]'
        };

        for (const [key, selector] of Object.entries(inputSelectors)) {
          const element = document.querySelector(selector);
          if (element && userInfo[key]) {
            setInputValue(element, userInfo[key]);
            await delay(300);
          }
        }

        const radioSelections = [
          {
            selector: `input[name="gender"][value="${userInfo?.gender == "男性" ? "male" : "female"}"]`,
            waitTime: 300
          },
          {
            selector: 'input[name="otherRelationship"][value="other"]',
            waitTime: 300
          },
          {
            selector: 'input[name="gc2024Sources"][value="other"]',
            waitTime: 300
          },
          {
            selector: 'input[name="policyApproval"]',
            waitTime: 300
          }
        ];

        for (const {selector, waitTime} of radioSelections) {
          const element = document.querySelector(selector);
          if (element) {
            setRadioValue(element);
            await delay(waitTime);
          }
        }

        await delay(500);

        Flutter.postMessage('自動入力が完了しました');

        if (confirm('すべての自動入力が完了しました。送信しますか？')) {
          const formData = new FormData(form);
          let allFieldsFilled = true;
          const emptyFields = [];

          for (const [name, value] of formData.entries()) {
            if (!value) {
              allFieldsFilled = false;
              emptyFields.push(name);
            }
          }

          if (!allFieldsFilled) {
            Flutter.postMessage('未入力のフィールドがあります: ' + emptyFields.join(', '));
            return;
          }

          const submitEvent = new Event('submit', { bubbles: true, cancelable: true });
          form.dispatchEvent(submitEvent);
        }

      } catch (error) {
        Flutter.postMessage('自動入力中にエラーが発生しました: ' + error.message);
        console.error('Auto input error:', error);
      }
    }

    autoInput();
    ''';
  }
}
