﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПрочитатьРасписание(Параметры.Начало, Параметры.Окончание, Параметры.РабочийЦентр);
	
	Если Параметры.Свойство("НовыйСтатус") И ЗначениеЗаполнено(Параметры.НовыйСтатус) Тогда
		СтрокаПодстановки = НСтр("ru = 'Операции РЦ с синхронной загрузкой (выполнение %1)'");
		ПредставлениеДействия = НРег(Строка(Параметры.НовыйСтатус));
		
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, ПредставлениеДействия);
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого Строка Из Расписание Цикл
		Строка.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого Строка Из Расписание Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)

	Закрыть(РезультатЗакрытияФормы());
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьРасписание(Начало, Окончание, РабочийЦентр)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОперацииДляДиспетчирования.ИдентификаторОперации,
	|	ОперацииДляДиспетчирования.РабочийЦентр КАК РабочийЦентр,
	|	ОперацииДляДиспетчирования.МаршрутныйЛист,
	|	ОперацииДляДиспетчирования.Начало КАК Начало,
	|	ОперацииДляДиспетчирования.Окончание КАК Окончание,
	|	ОперацииДляДиспетчирования.Загрузка КАК Загрузка,
	|	ОперацииДляДиспетчирования.РабочийЦентр.ВидРабочегоЦентра.ЕдиницаИзмеренияЗагрузки КАК ЕдиницаИзмеренияЗагрузки,
	|	ИСТИНА КАК Пометка
	|ИЗ
	|	РегистрСведений.ОперацииДляДиспетчирования КАК ОперацииДляДиспетчирования
	|ГДЕ
	|	ОперацииДляДиспетчирования.Начало = &Начало
	|	И ОперацииДляДиспетчирования.Окончание = &Окончание
	|	И ОперацииДляДиспетчирования.РабочийЦентр = &РабочийЦентр
	|	И ОперацииДляДиспетчирования.МаршрутныйЛист.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыМаршрутныхЛистовПроизводства.КВыполнению), ЗНАЧЕНИЕ(Перечисление.СтатусыМаршрутныхЛистовПроизводства.Выполнен))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Начало,
	|	Окончание,
	|	РабочийЦентр");
	
	Запрос.УстановитьПараметр("Начало", Начало);
	Запрос.УстановитьПараметр("Окончание", Окончание);
	Запрос.УстановитьПараметр("РабочийЦентр", РабочийЦентр);
	
	ДанныеРасписания = Запрос.Выполнить().Выгрузить();
	Если ЗначениеЗаполнено(ДанныеРасписания) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеРасписания[0], "Начало, Окончание, РабочийЦентр");
		Расписание.Загрузить(ДанныеРасписания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РезультатЗакрытияФормы()
	
	Операции = Новый Массив;
	
	Для каждого Строка Из Расписание Цикл
		Если Строка.Пометка Тогда
			Операции.Добавить(Строка.ИдентификаторОперации);
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Операции) Тогда
		Возврат Операции;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти