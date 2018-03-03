﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Сумма") Тогда
		СуммаДоговора = Параметры.Сумма;
	ИначеЕсли ЗначениеЗаполнено(Объект.Договор) Тогда
		СуммаДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "Сумма");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПересчитатьПроценты(ЭтаФорма);
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыГрафика = Новый Структура;
	ПараметрыГрафика.Вставить("Договор", Объект.Договор);
	ПараметрыГрафика.Вставить("СуммаДоговора", СуммаДоговора);
	
	Оповестить("Запись_ГрафикИсполненияДоговора", ПараметрыГрафика, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормыГрафик

&НаКлиенте
Процедура СуммаДоговораПриИзменении(Элемент)
	
	ПересчитатьПроценты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаИсполненияДоговораПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказатели(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаИсполненияДоговораПроцентОплатыПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыГрафикаИсполненияДоговора.ТекущиеДанные;
	
	Если ТекущиеДанные.ПроцентОплаты > 0 И Объект.ЭтапыГрафикаИсполненияДоговора.Итог("ПроцентОплаты") = 100 Тогда
		
		СуммаОплаты = 0;
		Для Каждого ТекСтрока Из Объект.ЭтапыГрафикаИсполненияДоговора Цикл
			Если ТекСтрока.НомерСтроки <> ТекущиеДанные.НомерСтроки Тогда
				СуммаОплаты = СуммаОплаты + ТекСтрока.СуммаОплаты;
			КонецЕсли;
		КонецЦикла;
		ТекущиеДанные.СуммаОплаты = СуммаДоговора - СуммаОплаты;
	Иначе
		
		ТекущиеДанные.СуммаОплаты = СуммаДоговора * ТекущиеДанные.ПроцентОплаты / 100;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаИсполненияДоговораСуммаОплатыПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыГрафикаИсполненияДоговора.ТекущиеДанные;
	
	Если СуммаДоговора <> 0 Тогда
		
		Если ТекущиеДанные.СуммаОплаты <> 0
			И Объект.ЭтапыГрафикаИсполненияДоговора.Итог("СуммаОплаты") = СуммаДоговора Тогда
			
			ПроцентОплаты = 0;
			Для Каждого ТекСтрока Из Объект.ЭтапыГрафикаИсполненияДоговора Цикл
				Если ТекСтрока.НомерСтроки <> ТекущиеДанные.НомерСтроки Тогда
					ПроцентОплаты = ПроцентОплаты + ТекСтрока.ПроцентОплаты;
				КонецЕсли;
			КонецЦикла;
			
			ТекущиеДанные.ПроцентОплаты = 100 - ПроцентОплаты;
			
		Иначе
			ТекущиеДанные.ПроцентОплаты = ТекущиеДанные.СуммаОплаты * 100 / СуммаДоговора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаИсполненияДоговораПроцентИсполненияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыГрафикаИсполненияДоговора.ТекущиеДанные;
	
	Если ТекущиеДанные.ПроцентИсполнения > 0 И Объект.ЭтапыГрафикаИсполненияДоговора.Итог("ПроцентИсполнения") = 100 Тогда
		
		СуммаИсполнения = 0;
		Для Каждого ТекСтрока Из Объект.ЭтапыГрафикаИсполненияДоговора Цикл
			Если ТекСтрока.НомерСтроки <> ТекущиеДанные.НомерСтроки Тогда
				СуммаИсполнения = СуммаИсполнения + ТекСтрока.СуммаИсполнения;
			КонецЕсли;
		КонецЦикла;
		ТекущиеДанные.СуммаИсполнения = СуммаДоговора - СуммаИсполнения;
	Иначе
		
		ТекущиеДанные.СуммаИсполнения = СуммаДоговора * ТекущиеДанные.ПроцентИсполнения / 100;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаИсполненияДоговораСуммаИсполненияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыГрафикаИсполненияДоговора.ТекущиеДанные;
	
	Если СуммаДоговора <> 0 Тогда
		
		Если ТекущиеДанные.СуммаИсполнения <> 0
			И Объект.ЭтапыГрафикаИсполненияДоговора.Итог("СуммаИсполнения") = СуммаДоговора Тогда
			
			ПроцентИсполнения = 0;
			Для Каждого ТекСтрока Из Объект.ЭтапыГрафикаИсполненияДоговора Цикл
				Если ТекСтрока.НомерСтроки <> ТекущиеДанные.НомерСтроки Тогда
					ПроцентИсполнения = ПроцентИсполнения + ТекСтрока.ПроцентИсполнения;
				КонецЕсли;
			КонецЦикла;
			
			ТекущиеДанные.ПроцентИсполнения = 100 - ПроцентИсполнения;
			
		Иначе
			ТекущиеДанные.ПроцентИсполнения = ТекущиеДанные.СуммаИсполнения * 100 / СуммаДоговора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьУсловноеОформление();
	
	РассчитатьИтоговыеПоказатели(ЭтаФорма);
	
	ТипДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "ТипДоговора");
	
	Если ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
		Или ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем Тогда
		
		Элементы.ЭтапыГрафикаИсполненияДоговораГруппаИсполнение.Заголовок = НСтр("ru='Отгрузка'");
		
	ИначеЕсли ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
		Или ТипДоговора = Перечисления.ТипыДоговоров.Импорт
		Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком Тогда
		
		Элементы.ЭтапыГрафикаИсполненияДоговораГруппаИсполнение.Заголовок = НСтр("ru='Поступление'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаИсполненияДоговораПроцентОплаты.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаИсполненияДоговора.ПроцентОплатыЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаИсполненияДоговораПроцентИсполнения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаИсполненияДоговора.ПроцентИсполненияЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказатели(Форма)
	
	ПредыдущееЗначениеДаты = Дата(1,1,1);
	Форма.ПроцентОплатОбщий = 0;
	Форма.ПроцентИсполненияОбщий = 0;
	
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаИсполненияДоговора Цикл
		
		Форма.ПроцентОплатОбщий = Форма.ПроцентОплатОбщий + ТекСтрока.ПроцентОплаты;
		ТекСтрока.ПроцентОплатыЗаполненНеверно = (Форма.ПроцентОплатОбщий > 100);
		Если Форма.ПроцентОплатОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
		
		Форма.ПроцентИсполненияОбщий = Форма.ПроцентИсполненияОбщий + ТекСтрока.ПроцентИсполнения;
		ТекСтрока.ПроцентИсполненияЗаполненНеверно = (Форма.ПроцентИсполненияОбщий > 100);
		Если Форма.ПроцентИсполненияОбщий = 100 Тогда
			Форма.НомерСтрокиПолногоИсполнения = ТекСтрока.НомерСтроки;
		КонецЕсли;
		
		ТекСтрока.ДатаЗаполненаНеверно = (ПредыдущееЗначениеДаты > ТекСтрока.ДатаПоГрафику);
		ПредыдущееЗначениеДаты = ТекСтрока.ДатаПоГрафику;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьПроценты(Форма)
	
	Если Форма.СуммаДоговора <> 0 Тогда
		Для каждого ЭтапГрафика Из Форма.Объект.ЭтапыГрафикаИсполненияДоговора Цикл
			
			Если ЭтапГрафика.СуммаОплаты <> 0 Тогда
				ЭтапГрафика.ПроцентОплаты = ЭтапГрафика.СуммаОплаты * 100 / Форма.СуммаДоговора;
			КонецЕсли;
			
			Если ЭтапГрафика.СуммаИсполнения <> 0 Тогда
				ЭтапГрафика.ПроцентИсполнения = ЭтапГрафика.СуммаИсполнения * 100 / Форма.СуммаДоговора;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти