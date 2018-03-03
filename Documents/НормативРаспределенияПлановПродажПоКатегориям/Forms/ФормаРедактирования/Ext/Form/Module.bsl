﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НаДату = ТекущаяДатаСеанса();
	
	УстановитьДоступность(ЭтаФорма);
	
	ОбновитьСписок();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТоварнаяКатегория  = Настройки.Получить("ТоварнаяКатегория");
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
		Реквизит = Настройки.Получить("Реквизит");
	Иначе
		Реквизит = Неопределено;
	КонецЕсли; 
	
	ОбновитьСписок();
	
	УстановитьДоступность(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТоварнаяКатегорияПриИзменении(Элемент)
	
	УстановитьДоступность(ЭтаФорма);
	
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
	
		ОтборТоварнаяКатегорияПриИзмененииНаСервере();
		
	Иначе
		
		Реквизит = Неопределено;
		ОбновитьСписок();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРеквизитПриИзменении(Элемент)
	
	ОбновитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНормативы

&НаКлиенте
Процедура НормативыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено 
		И Элемент.ТекущиеДанные.Свойство("Регистратор")
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Регистратор) Тогда
	
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Регистратор);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНормативыРаспределения(Команда)
	
	ОткрытьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.ФормаСписка"); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНормативы(Команда)
	
	Если Элементы.Нормативы.ТекущиеДанные <> Неопределено 
		И Элементы.Нормативы.ТекущиеДанные.Свойство("Регистратор")
		И ЗначениеЗаполнено(Элементы.Нормативы.ТекущиеДанные.Регистратор) Тогда
		
		ПоказатьЗначение(, Элементы.Нормативы.ТекущиеДанные.Регистратор);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеИспользовать(Команда)
	
	Если Элементы.Нормативы.ВыделенныеСтроки.Количество() > 0 Тогда 
		
		ЕстьДействующийНорматив = Ложь;
		Для каждого ВыделеннаяСтрока Из Элементы.Нормативы.ВыделенныеСтроки Цикл
		
			Норматив = Нормативы.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если Норматив <> Неопределено
				И ЗначениеЗаполнено(Норматив.ТоварнаяКатегория) 
				И ЗначениеЗаполнено(Норматив.Реквизит) 
				И Норматив.Действует Тогда
				
				ЕстьДействующийНорматив = Истина;
				Прервать;
				
			КонецЕсли;
		
		КонецЦикла; 
		
		Если НЕ ЕстьДействующийНорматив Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Необходимо выбрать в списке хотя бы один действующий норматив.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
			
		Иначе
		
			ТекстВопроса = НСтр("ru = 'Установить ""Не использовать"" для выбранных нормативов с %Дата%?'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Дата%", Формат(?(ЗначениеЗаполнено(НаДату), НаДату, ТекущаяДата()), "ДЛФ=D"));
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Установить ""Не использовать""'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
			
			Оповещение = Новый ОписаниеОповещения("НеИспользоватьЗавершение", ЭтотОбъект);
			
			ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		
		КонецЕсли; 
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Необходимо выбрать в списке хотя бы один действующий норматив.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ДатаНачалаДействия", НаДату);
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
		ЗначенияЗаполнения.Вставить("ТоварнаяКатегория", ТоварнаяКатегория);
	Иначе
		
		ТекущиеДанные = Элементы.Нормативы.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ЗначенияЗаполнения.Вставить("ТоварнаяКатегория", ТекущиеДанные.ТоварнаяКатегория);
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Реквизит) Тогда
		ЗначенияЗаполнения.Вставить("Реквизит", Реквизит);
	Иначе
		
		ТекущиеДанные = Элементы.Нормативы.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ЗначенияЗаполнения.Вставить("Реквизит", ТекущиеДанные.Реквизит);
		КонецЕсли; 
		
	КонецЕсли; 
	ЗначенияЗаполнения.Вставить("ЗаполнятьЗначения", Истина);
	ЗначенияЗаполнения.Вставить("Операция", ПредопределенноеЗначение("Перечисление.ОперацииНормативовРаспределения.УстановкаНорматива"));
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Форма = ПолучитьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.ФормаОбъекта", ПараметрыФормы, ЭтаФорма); 
	
	ДополнительныеПараметры = Новый Структура("Форма",Форма);
	Оповещение = Новый ОписаниеОповещения("ОткрытиеФормыНормативаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Форма.Открыть();
	
	Форма.ОписаниеОповещенияОЗакрытии = Оповещение;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытиеФормыНормативаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если ДополнительныеПараметры.Свойство("Форма") Тогда
	
		Форма = ДополнительныеПараметры.Форма;
		Если ЗначениеЗаполнено(Форма.Объект.Ссылка) 
			И Форма.Объект.Проведен
			И ЗначениеЗаполнено(Форма.Объект.ТоварнаяКатегория)
			И ЗначениеЗаполнено(Форма.Объект.Реквизит) Тогда
			
			ТоварныеКатегории = Нормативы.ПолучитьЭлементы();
			Для каждого ЭлементТоварнаяКатегория Из ТоварныеКатегории Цикл
			
				Если ЭлементТоварнаяКатегория.ТоварнаяКатегория = Форма.Объект.ТоварнаяКатегория Тогда
					
					НайденныйНорматив = Неопределено;
					ЭлементыНормативы = ЭлементТоварнаяКатегория.ПолучитьЭлементы();
					Для каждого ЭлементНорматив Из ЭлементыНормативы Цикл
						Если ЭлементНорматив.Реквизит = Форма.Объект.Реквизит Тогда
							НайденныйНорматив = ЭлементНорматив;
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если НайденныйНорматив = Неопределено Тогда
						ЭлементНорматив = ЭлементыНормативы.Добавить();
					Иначе
						ЭлементНорматив = НайденныйНорматив;
					КонецЕсли; 
					
					ЭлементНорматив.Норматив                  = Форма.Объект.Ссылка;
					ЭлементНорматив.Регистратор               = Форма.Объект.Ссылка;
					ЭлементНорматив.ТоварнаяКатегория         = Форма.Объект.ТоварнаяКатегория;
					ЭлементНорматив.Реквизит                  = Форма.Объект.Реквизит;
					ЭлементНорматив.Период                    = Форма.Объект.ДатаНачалаДействия;
					ЭлементНорматив.ПоХарактеристикам         = Форма.Объект.ВариантЗаполнения = 2;
					ЭлементНорматив.ТоварнаяКатегорияРеквизит = Форма.Объект.Реквизит;
					ЭлементНорматив.Действует                 = Истина;
					
					Если Форма.Объект.ВариантЗаполнения = 2 Тогда
						ЭлементНорматив.ИндексКартинки = 2;
					Иначе
						ЭлементНорматив.ИндексКартинки = 1;
					КонецЕсли; 
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
		
		ДополнительныеПараметры.Форма = Неопределено;
	
	Иначе
	
		ОбновитьСписок();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварныеКатегории.Ссылка КАК ТоварнаяКатегория,
	|	НормативыРаспределенияСрезПоследних.Реквизит,
	|	НормативыРаспределенияСрезПоследних.Норматив,
	|	НормативыРаспределенияСрезПоследних.Действует,
	|	НормативыРаспределенияСрезПоследних.ПоХарактеристикам,
	|	НормативыРаспределенияСрезПоследних.Период,
	|	НормативыРаспределенияСрезПоследних.Регистратор,
	|	ТоварныеКатегории.ПометкаУдаления КАК ТоварнаяКатегорияПометкаУдаления
	|ИЗ
	|	Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативыРаспределенияПлановПродажПоКатегориям.СрезПоследних(
	|				&НаДату,
	|				%ОтборТоварнаяКатегория1%
	|					%ОтборРеквизит%) КАК НормативыРаспределенияСрезПоследних
	|		ПО ТоварныеКатегории.Ссылка = НормативыРаспределенияСрезПоследних.ТоварнаяКатегория
	|ГДЕ
	|	НЕ ТоварныеКатегории.ЭтоГруппа
	|	%ОтборТоварнаяКатегория2%
	|ИТОГИ ПО
	|	ТоварнаяКатегория";
	
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("Реквизит", Реквизит);
	Запрос.УстановитьПараметр("ТоварнаяКатегория", ТоварнаяКатегория);
	
	ОтборТоварнаяКатегория1 = "";
	ОтборТоварнаяКатегория2 = "";
	ОтборРеквизит = "";
	
	Если ЗначениеЗаполнено(ТоварнаяКатегория) Тогда
	
		ОтборТоварнаяКатегория1 = "ТоварнаяКатегория = &ТоварнаяКатегория";
		ОтборТоварнаяКатегория2 = "И ТоварныеКатегории.Ссылка = &ТоварнаяКатегория";
	
	КонецЕсли; 
	Если ЗначениеЗаполнено(Реквизит) Тогда
	
		ОтборРеквизит = "И Реквизит = &Реквизит";
	
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборТоварнаяКатегория1%", ОтборТоварнаяКатегория1);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборТоварнаяКатегория2%", ОтборТоварнаяКатегория2);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборРеквизит%", ОтборРеквизит);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаТоварнаяКатегория = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТоварныеКатегории = Нормативы.ПолучитьЭлементы();
	ТоварныеКатегории.Очистить();
	
	Пока ВыборкаТоварнаяКатегория.Следующий() Цикл
		
		НоваяСтрокаТоварнаяКатегория = ТоварныеКатегории.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТоварнаяКатегория, ВыборкаТоварнаяКатегория);
		НоваяСтрокаТоварнаяКатегория.ТоварнаяКатегорияРеквизит = НоваяСтрокаТоварнаяКатегория.ТоварнаяКатегория;
		
		ВыборкаДетальныеЗаписи = ВыборкаТоварнаяКатегория.Выбрать();
		Реквизиты =  НоваяСтрокаТоварнаяКатегория.ПолучитьЭлементы();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.ТоварнаяКатегорияПометкаУдаления Тогда
				НоваяСтрокаТоварнаяКатегория.ИндексКартинки = 3;
			Иначе
				НоваяСтрокаТоварнаяКатегория.ИндексКартинки = 0;
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Реквизит) Тогда
				Продолжить;
			КонецЕсли; 
			
			НоваяСтрокаРеквизит = Реквизиты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаРеквизит, ВыборкаДетальныеЗаписи);
			НоваяСтрокаРеквизит.ТоварнаяКатегорияРеквизит = НоваяСтрокаРеквизит.Реквизит;
			
			Если НоваяСтрокаРеквизит.ПоХарактеристикам Тогда
				Если ВыборкаДетальныеЗаписи.Действует Тогда
					НоваяСтрокаРеквизит.ИндексКартинки = 2;
				Иначе
					НоваяСтрокаРеквизит.ИндексКартинки = 5;
				КонецЕсли; 
			Иначе
				Если НоваяСтрокаРеквизит.Действует Тогда
					НоваяСтрокаРеквизит.ИндексКартинки = 1;
				Иначе
					НоваяСтрокаРеквизит.ИндексКартинки = 4;
				КонецЕсли; 
			КонецЕсли; 
			
		КонецЦикла;
	КонецЦикла;
	
	Элементы.Нормативы.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;
	Элементы.Нормативы.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	
КонецПроцедуры 

&НаСервере
Процедура ОтборТоварнаяКатегорияПриИзмененииНаСервере()

	ЗаполнитьСписокРеквизитов();
	Элементы.Нормативы.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	ОбновитьСписок();

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступность(Форма)

	Если ЗначениеЗаполнено(Форма.ТоварнаяКатегория) Тогда
	
		Форма.Элементы.ОтборРеквизит.Доступность = Истина;
	
	Иначе
	
		Форма.Элементы.ОтборРеквизит.Доступность = Ложь;
	
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитов()

	СтруктураРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьРеквизитыДляНормативов();
	
	Элементы.ОтборРеквизит.СписокВыбора.Очистить();
	Для каждого КлючЗначение Из СтруктураРеквизитов Цикл
		Элементы.ОтборРеквизит.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение.Представление);
	КонецЦикла; 
	
	СписокДопРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьДополнительныеРеквизитыДляНормативов(ТоварнаяКатегория);
	
	Для каждого ЭлементСписка Из СписокДопРеквизитов Цикл
		Элементы.ОтборРеквизит.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры 

&НаКлиенте
Процедура НеИспользоватьЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		КоличествоВсего = Элементы.Нормативы.ВыделенныеСтроки.Количество();
		КоличествоОбработанных = СоздатьДокументыБлокировкиНормативовНаСервере(?(ЗначениеЗаполнено(НаДату), НаДату, ТекущаяДата()));
		
		ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных в списке нормативов установлена блокировка использования.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        КоличествоВсего);
		
		ТекстЗаголовка = НСтр("ru='Блокировка норматива установлена'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументыБлокировкиНормативовНаСервере(ДатаНачалаДействия)
	
	КоличествоОбъектов = 0;
	Для каждого ВыбраннаяСтрока Из Элементы.Нормативы.ВыделенныеСтроки Цикл
		
		Норматив = Нормативы.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если Норматив = Неопределено 
			ИЛИ НЕ ЗначениеЗаполнено(Норматив.ТоварнаяКатегория) 
			ИЛИ НЕ ЗначениеЗаполнено(Норматив.Реквизит)
			ИЛИ НЕ Норматив.Действует Тогда
			Продолжить;
		КонецЕсли; 
		
		Объект = Документы.НормативРаспределенияПлановПродажПоКатегориям.СоздатьДокумент();
		Объект.Дата = ТекущаяДатаСеанса();
		Если ЗначениеЗаполнено(Норматив.Период) И Норматив.Период = ДатаНачалаДействия Тогда
			Объект.ДатаНачалаДействия = КонецДня(ДатаНачалаДействия) + 1;
			Объект.Комментарий = НСтр("ru = 'Блокировка установлена следующей датой т.к. совпадает с датой начала действия норматива.'");
		Иначе
			Объект.ДатаНачалаДействия = ДатаНачалаДействия;
		КонецЕсли; 
		
		Объект.Операция = Перечисления.ОперацииНормативовРаспределения.БлокировкаНорматива;
		Объект.ТоварнаяКатегория = Норматив.ТоварнаяКатегория;
		Объект.Реквизит = Норматив.Реквизит;
		
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		
		Попытка
		
			Объект.Записать(РежимЗаписиДокумента.Проведение);
			КоличествоОбъектов = КоличествоОбъектов + 1;
		
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Данные.Проведение'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),УровеньЖурналаРегистрации.Ошибка, Документы.НормативРаспределенияПлановПродажПоКатегориям,, ОписаниеОшибки());
		КонецПопытки; 
	
	КонецЦикла; 
	
	ОбновитьСписок();
	
	Возврат КоличествоОбъектов;
	
КонецФункции

#КонецОбласти
