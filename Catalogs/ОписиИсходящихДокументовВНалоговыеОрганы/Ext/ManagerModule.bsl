﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Обработчик обновления БРО .
Процедура ОбновитьОписиИсходящихДокументов() Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОписиИсходящихДокументовВНалоговыеОрганы.Ссылка КАК ОписьСсылка
	|ИЗ
	|	Справочник.ОписиИсходящихДокументовВНалоговыеОрганы КАК ОписиИсходящихДокументовВНалоговыеОрганы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОтправки КАК СтатусыОтправки
	|		ПО (СтатусыОтправки.Объект = ОписиИсходящихДокументовВНалоговыеОрганы.Ссылка)
	|ГДЕ
	|	ЕСТЬNULL(СтатусыОтправки.Статус, &СтатусВКонверте) = &СтатусВКонверте";	
	
	Запрос.УстановитьПараметр("СтатусВКонверте", Перечисления.СтатусыОтправки.ВКонверте);
	Результат = Запрос.Выполнить();
	
	ВыборкаРезультата = Результат.Выбрать();
	
	Пока ВыборкаРезультата.Следующий() Цикл
		КонтекстЭДОСервер.ОбновитьФайлыДокументовИБОписиИсходящихДокументов(ВыборкаРезультата.ОписьСсылка);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО .
Процедура ОбновитьНаименованиеВсехОписейИсходящихДокументов() Экспорт
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОписиИсходящихДокументовВНалоговыеОрганы.Ссылка КАК ОписьСсылка
	|ИЗ
	|	Справочник.ОписиИсходящихДокументовВНалоговыеОрганы КАК ОписиИсходящихДокументовВНалоговыеОрганы";	
	
	Результат = Запрос.Выполнить();
	
	ВыборкаРезультата = Результат.Выбрать();
	
	Пока ВыборкаРезультата.Следующий() Цикл
		ОписьОбъект = ВыборкаРезультата.ОписьСсылка.ПолучитьОбъект();
		
		Требование = ОписьОбъект.Требование;
		Наименование = НСтр("ru = 'Ответ на требование о представлении документов'");
		Если ЗначениеЗаполнено(Требование) Тогда
			Наименование = Наименование + " " + Строка(Требование.НомерДокумента) + " от " + Формат(Требование.ДатаДокумента, "ДЛФ=D");
		КонецЕсли;
		
		ОписьОбъект.Наименование = Наименование;
		
		ОписьОбъект.ОбменДанными.Загрузка = Истина;
		ОписьОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "ОписиИсходящихДокументовВНалоговыеОрганы", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	

КонецПроцедуры

#КонецОбласти
