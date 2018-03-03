﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ЗаявлениеДСВ1;

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
				   
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();				   
	
	СтандартнаяОбработка = ложь;
	
	ДокументРезультат.Очистить();
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	
	НастройкиОтчета = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();
	
	НастройкиОтчета.Выбор.Элементы.Очистить();
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра <> Неопределено Тогда
		
		Если ТипЗнч(ЗначениеПараметра.Значение) = Тип("Дата") 
			Или ТипЗнч(ЗначениеПараметра.Значение) = Тип("СтандартнаяДатаНачала") Тогда
			
			ДатаОтчета = Дата(ЗначениеПараметра.Значение);
			
			Если ДатаОтчета = '00010101' Тогда
				ЗначениеПараметра.Значение = ТекущаяДатаСеанса();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Данные = Новый ДеревоЗначений;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Создадим и инициализируем процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Данные);
	
	Макет         = УправлениеПечатью.МакетПечатнойФормы("Отчет.ЗаявлениеДСВ1.ПФ_MXL_ФормаДСВ_1");
	ЗаявлениеДСВ1 = Макет.ПолучитьОбласть("ЗаявлениеДСВ1");
	
	// Обозначим начало вывода
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	Группировки = ЗарплатаКадрыОтчеты.ПолучитьПоляГруппировок(ЭтотОбъект.КомпоновщикНастроек);
	
	ВывестиМакетыСГруппировками(ДокументРезультат, Данные, Группировки);
	
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
КонецПроцедуры

Процедура ВывестиМакетыСГруппировками(ДокументРезультат, Данные, Группировки)
	
	Если Группировки.Количество() > 0 Тогда
	
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
		
			ПолеДанных = Группировки[0].Значение;
			ВывестиГруппировку(ДокументРезультат, СтрокаДанных, ПолеДанных, 0);
			ВывестиВложенныеГруппировкиСМакетами(ДокументРезультат, СтрокаДанных, Группировки, 1);
		
		КонецЦикла;
	Иначе
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
			
			ВывестиМакет(ДокументРезультат, СтрокаДанных, 0)
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиВложенныеГруппировкиСМакетами(ДокументРезультат, Данные, Группировки, Уровень)
	
	Если Группировки.Количество() > Уровень Тогда 
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
		
			ПолеДанных = Группировки[Уровень].Значение;
			ВывестиГруппировку(ДокументРезультат, СтрокаДанных, ПолеДанных, Уровень);
			ВывестиВложенныеГруппировкиСМакетами(ДокументРезультат, СтрокаДанных, Группировки, Уровень + 1);
		
		КонецЦикла;
		
	Иначе
		Для Каждого СтрокаДанных Из Данные.Строки Цикл
			
			ВывестиМакет(ДокументРезультат, СтрокаДанных, Уровень)
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиГруппировку(ДокументРезультат, СтрокаДанных, Поле, Уровень)
	
	МакетГруппировки  = УправлениеПечатью.МакетПечатнойФормы("Отчет.ЗаявлениеДСВ1.МакетГруппировки");
	ОбластьГруппировки = МакетГруппировки.ПолучитьОбласть("Группировка");
	
	ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.НайтиПоле(Новый ПолеКомпоновкиДанных(Поле));
	
	ОбластьГруппировки.Параметры.НазваниеПараметра = ДоступноеПоле.Заголовок;
	
	Если Поле = "МесяцНачисления" Тогда
		ОбластьГруппировки.Параметры.Значение = Формат(СтрокаДанных[СтрЗаменить(Поле, ".", "")], "ДФ='ММММ гггг'");
	Иначе
		ОбластьГруппировки.Параметры.Значение = СтрокаДанных[СтрЗаменить(Поле, ".", "")];
	КонецЕсли;
	
	ДокументРезультат.Вывести(ОбластьГруппировки, Уровень);
	
КонецПроцедуры 

Процедура ВывестиМакет(ДокументРезультат, СтрокаДанных, Уровень) 
	
	ЗаявлениеДСВ1.Параметры.Заполнить(СтрокаДанных);
	
	НомерПФР = СтрЗаменить(СтрЗаменить(СтрокаДанных.СтраховойНомерПФР, "-", ""), " ", "");
	ЗаявлениеДСВ1.Параметры.НомерПФР_1 = Сред(НомерПФР, 1, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_2 = Сред(НомерПФР, 2, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_3 = Сред(НомерПФР, 3, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_4 = Сред(НомерПФР, 4, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_5 = Сред(НомерПФР, 5, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_6 = Сред(НомерПФР, 6, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_7 = Сред(НомерПФР, 7, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_8 = Сред(НомерПФР, 8, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_9 = Сред(НомерПФР, 9, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_10 = Сред(НомерПФР, 10, 1);
	ЗаявлениеДСВ1.Параметры.НомерПФР_11 = Сред(НомерПФР, 11, 1);
	
	ВывестиАдрес(СтрокаДанных);
	
	ДокументРезультат.Вывести(ЗаявлениеДСВ1, Уровень);
	ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	
КонецПроцедуры

Процедура ВывестиАдрес(СтрокаДанных)
	Если ЗначениеЗаполнено(СтрокаДанных.АдресДляИнформирования) Тогда
		МаксимальнаяДлинаПервойСтрокиАдреса = 75;

		ЭлементыАдреса = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаДанных.АдресДляИнформирования, ",");		
		
		ИндексОбрабатываемогоЭлемента = 0;
		
		ЗаполняемаяСтрока = "";
		Пока ИндексОбрабатываемогоЭлемента <= ЭлементыАдреса.Количество() - 1 
			И СтрДлина(ЗаполняемаяСтрока + ЭлементыАдреса[ИндексОбрабатываемогоЭлемента] + ", ") < МаксимальнаяДлинаПервойСтрокиАдреса Цикл 
			
			ЗаполняемаяСтрока = ЗаполняемаяСтрока + ЭлементыАдреса[ИндексОбрабатываемогоЭлемента] + ", ";
			
			ИндексОбрабатываемогоЭлемента = ИндексОбрабатываемогоЭлемента + 1;
		КонецЦикла;	
		
		Если ИндексОбрабатываемогоЭлемента = ЭлементыАдреса.Количество() - 1 Тогда
			ЗаполняемаяСтрока = Сред(ЗаполняемаяСтрока, 1, СтрДлина(ЗаполняемаяСтрока) - 2);			
		КонецЕсли;

		ЗаявлениеДСВ1.Параметры.Адрес_1 = ЗаполняемаяСтрока;
		
		ЗаполняемаяСтрока = "";
		Для ИндексОбрабатываемогоЭлемента = ИндексОбрабатываемогоЭлемента По ЭлементыАдреса.Количество() - 1 Цикл
			ЗаполняемаяСтрока = ЗаполняемаяСтрока + ЭлементыАдреса[ИндексОбрабатываемогоЭлемента] + ", ";
		КонецЦикла;	
		
		ЗаполняемаяСтрока = Сред(ЗаполняемаяСтрока, 1, СтрДлина(ЗаполняемаяСтрока) - 2);

		ЗаявлениеДСВ1.Параметры.Адрес_2 = ЗаполняемаяСтрока;
	Иначе
		ЗаявлениеДСВ1.Параметры.Адрес_1 = "";
		ЗаявлениеДСВ1.Параметры.Адрес_2 = "";
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли