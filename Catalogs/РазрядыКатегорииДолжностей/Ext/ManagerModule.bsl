﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	КадровыйУчетРасширенныйВызовСервера.ОбработкаПолученияДанныхВыбораСправочникаРазрядыКатегорииДолжностей(ДанныеВыбора, Параметры, СтандартнаяОбработка);		
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='1 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='2 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='3 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='4 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='5 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='6 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='7 квалификационный уровень'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Первая квалификационная категория'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Вторая квалификационная категория'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='Высшая квалификационная категория'");
		
	Иначе
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='1 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='2 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='3 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='4 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='5 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='6 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='7 разряд (категория)'");
		
		НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
		НоваяСтрокаКлассификатора.Наименование = НСтр("ru='8 разряд (категория)'");
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РазрядыКатегорииДолжностей.Наименование
	|ИЗ
	|	Справочник.РазрядыКатегорииДолжностей КАК РазрядыКатегорииДолжностей";
	
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		Если ТаблицаСуществующих.Найти(СтрокаКлассификатора.Наименование,"Наименование")  = Неопределено Тогда
			СправочникОбъект = Справочники.РазрядыКатегорииДолжностей.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаКлассификатора);
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	КадровыйУчетРасширенный.ЗаполнитьРеквизитДопУпорядочиванияРазрядовДолжностей();
	
КонецПроцедуры

Процедура ЗаполнитьНаименованиеПолное() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазрядыКатегорииДолжностей.Ссылка
	|ИЗ
	|	Справочник.РазрядыКатегорииДолжностей КАК РазрядыКатегорииДолжностей
	|ГДЕ
	|	ПОДСТРОКА(РазрядыКатегорииДолжностей.НаименованиеПолное, 1, 150) = """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.НаименованиеПолное = Объект.Наименование;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗаполнитьТарифныеСетки() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	УтверждениеТарифнойСеткиТарифы.РазрядКатегория КАК РазрядКатегория,
			|	УтверждениеТарифнойСеткиТарифы.Ссылка.ТарифнаяСетка КАК ТарифнаяСетка
			|ИЗ
			|	Документ.УтверждениеТарифнойСетки.Тарифы КАК УтверждениеТарифнойСеткиТарифы
			|ГДЕ
			|	УтверждениеТарифнойСеткиТарифы.Ссылка.ВидТарифнойСетки = ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСеток.Тариф)
			|	И ВЫРАЗИТЬ(УтверждениеТарифнойСеткиТарифы.РазрядКатегория КАК Справочник.РазрядыКатегорииДолжностей).ТарифнаяСетка = ЗНАЧЕНИЕ(Справочник.ТарифныеСетки.ПустаяСсылка)
			|
			|УПОРЯДОЧИТЬ ПО
			|	РазрядКатегория,
			|	ТарифнаяСетка";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если Не РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				ОбъектСправочника = Выборка.РазрядКатегория.ПолучитьОбъект();
				ОбъектСправочника.ТарифнаяСетка = Выборка.ТарифнаяСетка;
				
				ОбъектСправочника.ОбменДанными.Загрузка = Истина;
				ОбъектСправочника.Записать();
				
			КонецЦикла; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
