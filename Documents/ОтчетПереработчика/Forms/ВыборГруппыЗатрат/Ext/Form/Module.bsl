﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоПродукции Тогда
		Заголовок = НСтр("ru = 'Выбор продукции'");
	ИначеЕсли Параметры.ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоСпецификациям Тогда
		Заголовок = НСтр("ru = 'Выбор спецификации продукции'");
	ИначеЕсли Параметры.ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоЗаказамНаПроизводство Тогда
		Заголовок = НСтр("ru = 'Выбор заказа'");
	ИначеЕсли Параметры.ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.ПоЭтапамПроизводства Тогда
		Заголовок = НСтр("ru = 'Выбор этапа'");
	КонецЕсли; 
	
	Элементы.СписокГруппГруппаЗатрат.Заголовок = Параметры.ЗаголовокГруппы;
	
	ИмяПоляГруппаЗатрат = Параметры.ИмяПоляГруппаЗатрат;
	
	Если Параметры.ПоЗаказам Тогда
		
		ДанныеЗаказа = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаДанныхЗаказа);
		Для каждого СтрокаУслуга Из ДанныеЗаказа.Услуги Цикл
			СтрокаГруппа = СписокГрупп.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаГруппа, СтрокаУслуга);
		КонецЦикла;
		
	Иначе
		
		ОтборПоДокументуПоступления = Неопределено;
		Параметры.Свойство("ОтборПоДокументуПоступления", ОтборПоДокументуПоступления);
		
		Для каждого СтрокаУслуга Из Параметры.Услуги Цикл
			Если ОтборПоДокументуПоступления = Неопределено
				ИЛИ СтрокаУслуга.ДокументПоступления = ОтборПоДокументуПоступления Тогда
				СтрокаГруппа = СписокГрупп.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаГруппа, СтрокаУслуга);
			КонецЕсли; 
		КонецЦикла;
		
		Если Параметры.ГруппировкаЗатрат = Перечисления.ГруппировкиЗатратВЗаказеПереработчику.БезГруппировки Тогда
			Элементы.СписокГруппГруппаЗатрат.Видимость = Ложь;
			Заголовок = НСтр("ru = 'Выбор поступления'")
		КонецЕсли; 
		
	КонецЕсли; 
	
	Элементы.СписокГруппДокументПоступления.Видимость = НЕ Параметры.ПоЗаказам;
	
	Для каждого СтрокаГруппа Из СписокГрупп Цикл
		Если Параметры.НомерГруппыЗатрат = СтрокаГруппа[ИмяПоляГруппаЗатрат] Тогда
			Элементы.СписокГрупп.ТекущаяСтрока = СтрокаГруппа.ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборГруппы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	
	ОбработатьВыборГруппы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборГруппы()

	ТекущиеДанные = Элементы.СписокГрупп.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбора = Новый Структура("ГруппаЗатрат,Спецификация,ДокументПоступления,НомерГруппыЗатрат,ЭтапПроизводства");
	ЗаполнитьЗначенияСвойств(ПараметрыВыбора, ТекущиеДанные);

	Закрыть(ПараметрыВыбора);

КонецПроцедуры

#КонецОбласти
