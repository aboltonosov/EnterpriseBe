﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	//установить базовую дату расчета прогноза закрытия сделок
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Сегодня", ТекущаяДатаСеанса());

	//исключить лишние поля в расшифровке по сделкам
	Структура = КомпоновщикНастроек.Настройки.Структура;
	ПолеСделка = Новый ПолеКомпоновкиДанных("Сделка");
	Для Каждого Элемент Из Структура Цикл
		Если Элемент.Имя = "Расшифровка" Тогда
			Если Элемент.ПоляГруппировки.Элементы.Количество() = 1
			   И Элемент.ПоляГруппировки.Элементы[0].Поле = ПолеСделка Тогда
				ПолеВероятность     = Новый ПолеКомпоновкиДанных("Вероятность");
				ПолеПотенциал       = Новый ПолеКомпоновкиДанных("СделкаПотенциальнаяСуммаПродажи");
				ПолеПрогнозЗакрытия = Новый ПолеКомпоновкиДанных("ПрогнозДатыЗакрытия");
				ВыбранныеПоля   = Элемент.Выбор.Элементы;
				Для Каждого ЭлементВыбора Из ВыбранныеПоля Цикл
					Если ЭлементВыбора.Поле = ПолеВероятность
					 Или ЭлементВыбора.Поле = ПолеПотенциал
					 Или ЭлементВыбора.Поле = ПолеПрогнозЗакрытия Тогда
						ЭлементВыбора.Использование = Ложь;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли