﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ПериодДействия") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.ПериодДействия) Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru='Причины перерасчета зарплаты за'") + " " + Формат(Параметры.Отбор.ПериодДействия,  "ДФ='ММММ гггг'");
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ПериодДействия", Параметры.Отбор.ПериодДействия);
				
			Если Параметры.Отбор.Свойство("Подразделение") Тогда
				
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
					Список, "ДокументНачисления", , ВидСравненияКомпоновкиДанных.Заполнено);
					
				Параметры.Отбор.Удалить("Подразделение");
				
			КонецЕсли; 
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ПериодДействия",
				"Видимость",
				Ложь);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ДокументыНачисления, "ПериодДействия", Параметры.Отбор.ПериодДействия);
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ДокументыНачисленияПериодДействия",
				"Видимость",
				Ложь);
			
		КонецЕсли; 
		
		Параметры.Отбор.Удалить("ПериодДействия");
		
	КонецЕсли; 
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Организация", Параметры.Отбор.Организация);
				
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"Организация",
				"Видимость",
				Ложь);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				ДокументыНачисления, "Организация", Параметры.Отбор.Организация);
				
		КонецЕсли;
			
		Параметры.Отбор.Удалить("Организация");	
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ДокументыНачисления, "Сотрудники", Справочники.Сотрудники.ПустаяСсылка());
		
	Если Параметры.Отбор.Свойство("Сотрудники") Тогда
		
		Если Не ПустаяСтрока(Параметры.Отбор.Сотрудники) Тогда
			
			Сотрудники = ПолучитьИзВременногоХранилища(Параметры.Отбор.Сотрудники);
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "Сотрудник", Сотрудники, ВидСравненияКомпоновкиДанных.ВСписке);
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				ДокументыНачисления, "Сотрудники", Сотрудники);
			
		КонецЕсли; 
		
		Параметры.Отбор.Удалить("Сотрудники");	
		
	КонецЕсли;
	
	Если Параметры.Свойство("ГруппироватьПоДокументамНачисления") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДокументыНачисления",
			"Видимость",
			Истина);
		
	КонецЕсли; 
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список", , , , "Организация,ПериодДействия,ДокументНачисления,Сотрудники,Сотрудник");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыНачисления

&НаКлиенте
Процедура ДокументыНачисленияПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ДокументыНачисления.ТекущиеДанные <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(
			Список, "ДокументНачисления");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДокументНачисления", Элементы.ДокументыНачисления.ТекущиеДанные.ДокументНачисления);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыНачисленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.ДокументНачисления)
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ТекущееЗначение = ТекущиеДанные[Поле.Имя];
		Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
			ПоказатьЗначение(, ТекущееЗначение);
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
