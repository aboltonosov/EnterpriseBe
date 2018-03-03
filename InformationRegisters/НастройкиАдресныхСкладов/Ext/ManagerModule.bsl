﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Процедура добавляет в регистр настройку подпитки по умолчанию, если
//еще нет настроек для склада (помещения) с адресным хранением.
//
//	Параметры:
//	Склад - СправочникСсылка.Склады - склад, для которого осуществляется настройка;
//	Помещение - СправочникСсылка.СкладскиеПомещения - складское помещение, для которого осуществляется настройка;
//	ИспользоватьАдресноеХранение - Булево, Истина - признак использования адресного хранения на складе / в помещении;
//	ДатаНачалаАдресногоХраненияОстатков - Дата - дата, с которой осуществляется использование адресного хранения 
//		остатков товаров на складе / в помещении;
//	ИспользоватьАдресноеХранениеСправочно - Булево, Истина - признак использования справочного хранения товаров 
//		на адресном складе / помещении;
//	ИспользоватьРабочиеУчастки - Булево, Истина - признак использования рабочих участков на складе / в помещении;
//	СкопироватьНастройкиВладельца - Булево, Истина - признак необходимости копирования настроек по складу 
//		в настройки помещения.
//
Процедура УстановитьНастройкиПоУмолчанию(Склад, Помещение, ИспользоватьАдресноеХранение,
										ДатаНачалаАдресногоХраненияОстатков, ИспользоватьАдресноеХранениеСправочно, ИспользоватьРабочиеУчастки,
										СкопироватьНастройкиВладельца = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	&Помещение КАК Помещение,
		|	НастройкиАдресныхСкладов.*
		|ИЗ
		|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
		|ГДЕ
		|	НастройкиАдресныхСкладов.Склад = &Склад";
	Если СкопироватьНастройкиВладельца Тогда
		Запрос.Текст = Запрос.Текст + "
			|	И НастройкиАдресныхСкладов.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)";
	Иначе
		Запрос.Текст = Запрос.Текст + "
			|	И НастройкиАдресныхСкладов.Помещение = &Помещение";
	КонецЕсли;
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Помещение", Помещение);
	
	Настройки = Запрос.Выполнить().Выбрать();
	
	Набор = РегистрыСведений.НастройкиАдресныхСкладов.СоздатьНаборЗаписей();
	Набор.Отбор.Склад.Установить(Склад);
	Набор.Отбор.Помещение.Установить(Помещение);
	
	СтрокаНастроек = Набор.Добавить();
	Если Настройки.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтрокаНастроек, Настройки);
	Иначе
		СтрокаНастроек.Склад = Склад;
		СтрокаНастроек.Помещение = Помещение;
		Набор.Заполнить(Неопределено);
	КонецЕсли;
	
	СтрокаНастроек.ИспользоватьАдресноеХранение          = ИспользоватьАдресноеХранение;
	СтрокаНастроек.ДатаНачалаАдресногоХраненияОстатков   = ДатаНачалаАдресногоХраненияОстатков;
	СтрокаНастроек.ИспользоватьАдресноеХранениеСправочно = ИспользоватьАдресноеХранениеСправочно;
	СтрокаНастроек.ИспользоватьРабочиеУчастки            = ИспользоватьРабочиеУчастки;
	
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрСведений.НастройкиАдресныхСкладов";
	
КонецФункции

// Регистрация данных к обработке при обновлении ИБ.
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиАдресныхСкладов.Склад КАК Склад,
	|	НастройкиАдресныхСкладов.Помещение КАК Помещение
	|ИЗ
	|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|ГДЕ
	|	НастройкиАдресныхСкладов.УдалитьРегламентноеЗаданиеСозданиеЗаданийНаПодпитку <> &ПустойГУИД
	|	И НастройкиАдресныхСкладов.УдалитьИспользоватьРегламентноеЗаданиеСозданияЗаданийНаПодпитку";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПустойГУИД", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	КлючиЗаписей = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, КлючиЗаписей, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработка данных при обновлении ИБ.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	Набор = РегистрыСведений.НастройкиАдресныхСкладов.СоздатьНаборЗаписей();
	Набор.Записывать = Истина;
	
	ВыборкаДетальныеЗаписи = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяРегистра());
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Склад", ВыборкаДетальныеЗаписи.Склад);
			ЭлементБлокировки.УстановитьЗначение("Помещение", ВыборкаДетальныеЗаписи.Помещение);
			
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			Продолжить;
			
		КонецПопытки;
		
		Набор.Отбор.Склад.Установить(ВыборкаДетальныеЗаписи.Склад);
		Набор.Отбор.Помещение.Установить(ВыборкаДетальныеЗаписи.Помещение);
		Набор.Прочитать();
		
		// Если между чтением в ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию 
		// и блокировкой запись была удалена.
		Если Не Набор.Количество() Тогда
			ОтменитьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		// Если между чтением в ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию
		// и блокировкой подпитка была отключена.
		Если Набор[0].УдалитьИспользоватьРегламентноеЗаданиеСозданияЗаданийНаПодпитку = Ложь Тогда
			ОтменитьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		РегЗаданиеНаПодпитку = РегламентныеЗаданияСервер.Задание(Набор[0].УдалитьРегламентноеЗаданиеСозданиеЗаданийНаПодпитку);
		РегЗаданиеНаПодпитку.Использование = Ложь;
		РегЗаданиеНаПодпитку.Записать();
		
		РегЗаданиеНаПеремещение = РегламентныеЗаданияСервер.ДобавитьЗадание(
			Новый Структура("Метаданные", Метаданные.РегламентныеЗадания.СозданиеЗаданийНаПеремещение));
		ЗаполнитьЗначенияСвойств(РегЗаданиеНаПеремещение, РегЗаданиеНаПодпитку);
		РегЗаданиеНаПеремещение.Параметры[0].Вставить(
			"ПравилоСозданияЗаданий", 
			Перечисления.ПравилаСозданияЗаданийНаОтборРазмещение.ПодпиткаЗонБыстрогоОтбора);
		РегЗаданиеНаПеремещение.Использование = Истина;
		РегЗаданиеНаПеремещение.Записать();
		
		Набор[0].РегламентныеЗаданияСозданияЗаданийНаПеремещение = Строка(РегЗаданиеНаПеремещение.УникальныйИдентификатор);
		Набор[0].УдалитьИспользоватьРегламентноеЗаданиеСозданияЗаданийНаПодпитку = Ложь;
			
		Попытка
				
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяРегистра());
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.НастройкаКонтроляОбеспечения,
				Неопределено,
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

// Регистрация данных к обработке при обновлении ИБ.
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию1(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра();
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиАдресныхСкладов.Склад КАК Склад,
	|	НастройкиАдресныхСкладов.Помещение КАК Помещение,
	|	НастройкиАдресныхСкладов.РегламентныеЗаданияСозданияЗаданийНаПеремещение
	|ИЗ
	|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|ГДЕ
	|	(ВЫРАЗИТЬ(НастройкиАдресныхСкладов.РегламентныеЗаданияСозданияЗаданийНаПеремещение КАК СТРОКА(50))) <> """"";
	Запрос = Новый Запрос(ТекстЗапроса);
	
	КлючиЗаписей = Новый ТаблицаЗначений;
	КлючиЗаписей.Колонки.Добавить("Склад", Новый ОписаниеТипов("СправочникСсылка.Склады"));
	КлючиЗаписей.Колонки.Добавить("Помещение", Новый ОписаниеТипов("СправочникСсылка.СкладскиеПомещения"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РегЗадания = СтрРазделить(Выборка.РегламентныеЗаданияСозданияЗаданийНаПеремещение, ",");
		
		Для Каждого РегЗадание Из РегЗадания Цикл
			РегЗаданиеНаПеремещение = РегламентныеЗаданияСервер.Задание(РегЗадание);
			Если ТипЗнч(РегЗаданиеНаПеремещение.Параметры[0].ПравилоСозданияЗаданий) = 
				Тип("ПеречислениеСсылка.УдалитьПравилаСозданияЗаданийНаОтборРазмещение") Тогда
				
				КлючЗаписейСтр = КлючиЗаписей.Добавить();
				КлючЗаписейСтр.Склад = Выборка.Склад;
				КлючЗаписейСтр.Помещение = Выборка.Помещение;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, КлючиЗаписей, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработка данных при обновлении ИБ.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию1(Параметры) Экспорт

	Набор = РегистрыСведений.НастройкиАдресныхСкладов.СоздатьНаборЗаписей();
	Набор.Записывать = Истина;
	
	ВыборкаДетальныеЗаписи = 
		ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
			Параметры.Очередь,
			ПолноеИмяРегистра());
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Склад", ВыборкаДетальныеЗаписи.Склад);
			ЭлементБлокировки.УстановитьЗначение("Помещение", ВыборкаДетальныеЗаписи.Помещение);
			
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			Продолжить;
			
		КонецПопытки;
		
		Набор.Отбор.Склад.Установить(ВыборкаДетальныеЗаписи.Склад);
		Набор.Отбор.Помещение.Установить(ВыборкаДетальныеЗаписи.Помещение);
		Набор.Прочитать();
		
		// Если между чтением в ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию 
		// и блокировкой запись была удалена.
		Если Не Набор.Количество() Тогда
			ОтменитьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		РегЗадания = СтрРазделить(Набор[0].РегламентныеЗаданияСозданияЗаданийНаПеремещение, ",");
		
		Для Каждого РегЗадание Из РегЗадания Цикл
			РегЗаданиеНаПеремещение = РегламентныеЗаданияСервер.Задание(РегЗадание);
			РегЗаданиеНаПеремещение.Параметры[0].ПравилоСозданияЗаданий = 
				ПравилоСозданияЗаданийНаПермещениеСНовымИД(РегЗаданиеНаПеремещение.Параметры[0].ПравилоСозданияЗаданий);
			РегЗаданиеНаПеремещение.Записать();
		КонецЦикла;
		
		Попытка
				
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяРегистра());
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.НастройкаКонтроляОбеспечения,
				Неопределено,
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра());
	
КонецПроцедуры

Функция ПравилоСозданияЗаданийНаПермещениеСНовымИД(ПравилоСозданияЗаданийНаПеремещениеСоСтарымИД)
	
	Если ПравилоСозданияЗаданийНаПеремещениеСоСтарымИД = 
		Перечисления.УдалитьПравилаСозданияЗаданийНаОтборРазмещение.ПеремещениеПоПравиламРазмещенияОбособленныхТоваров Тогда
		Возврат Перечисления.ПравилаСозданияЗаданийНаОтборРазмещение.ПеремещениеПоПравиламРазмещенияОбособленныхТоваров;
	ИначеЕсли ПравилоСозданияЗаданийНаПеремещениеСоСтарымИД = 
		Перечисления.УдалитьПравилаСозданияЗаданийНаОтборРазмещение.ПодпиткаЗонБыстрогоОтбора Тогда
		Возврат Перечисления.ПравилаСозданияЗаданийНаОтборРазмещение.ПодпиткаЗонБыстрогоОтбора;
	КонецЕсли;
	Возврат Перечисления.ПравилаСозданияЗаданийНаОтборРазмещение.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли