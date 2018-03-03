﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='Не найдено ошибочных записей'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсправитьРегистрации(Команда)
	
	ИсправитьРегистрацииНаСервере();
	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='Ошибки исправлены'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме(Отказ = Истина)
	
	ПроверитьИсториюРегистрацийВНалоговомОргане();
	
	Если ИсправляемыеРегистрации.Количество() = 0 И ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПроинициализироватьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ПроинициализироватьФорму();

	Если ИсправляемыеРегистрации.Количество() = 0 Тогда
		ТекущаяСтраница = Элементы.ГруппаСтраницы.ТекущаяСтраница;
	Иначе
		
		Если ИсправляемыеРегистрации.Количество() = 1 Тогда
			
			ТекущаяСтраница = Элементы.ГруппаОднаСтруктурнаяЕдиница;
			
			ТекстИнфонадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В учете обнаружены несоответствия периодов регистраций в налоговом органе периодам истории изменения.
					|Для подразделения %1 необходимо произвести восстановление записей о регистрации в налоговом органе, начиная с %2.'"),
				ИсправляемыеРегистрации[0].СтруктурнаяЕдиница,
				ИсправляемыеРегистрации[0].Период);
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ДекорацияОднаСтруктурнаяЕдиница",
				"Заголовок",
				ТекстИнфонадписи);
				
		Иначе
			ТекущаяСтраница = Элементы.ГруппаНесколькоСтруктурныхЕдиниц;
		КонецЕсли;
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСтраницы",
		"ТекущаяСтраница",
		ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИсториюРегистрацийВНалоговомОргане()
	
	ИсправляемыеРегистрации.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Обработки.ПерезаполнениеРегистрацийВНалоговомОргане.СоздатьВТПериодыДействияРегистраций(Запрос.МенеджерВременныхТаблиц);
	
	ОписанияРегистровСодержащихРегистрации = ЗарплатаКадры.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
	Для каждого ОписаниеРегистра Из ОписанияРегистровСодержащихРегистрации Цикл
		
		Если Не ОписаниеРегистра.ЕстьПодразделения Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ИсследуемыйРегистр.Период КАК Период,
			|	ИсследуемыйРегистр.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
			|	ИсследуемыйРегистр.Подразделение КАК СтруктурнаяЕдиница
			|ПОМЕСТИТЬ ВТПериодыРегистрацийРегистра
			|ИЗ
			|	&ИсследуемыйРегистр КАК ИсследуемыйРегистр";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсследуемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
		Запрос.Выполнить();
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	МИНИМУМ(ПериодыРегистрацийРегистра.Период) КАК Период,
			|	ПериодыДействияРегистраций.СтруктурнаяЕдиница
			|ИЗ
			|	ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыРегистрацийРегистра КАК ПериодыРегистрацийРегистра
			|		ПО ПериодыДействияРегистраций.СтруктурнаяЕдиница = ПериодыРегистрацийРегистра.СтруктурнаяЕдиница
			|			И ПериодыДействияРегистраций.Период <= ПериодыРегистрацийРегистра.Период
			|			И (ПериодыДействияРегистраций.ПериодПоследующий > ПериодыРегистрацийРегистра.Период
			|				ИЛИ ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1))
			|			И ПериодыДействияРегистраций.РегистрацияВНалоговомОргане <> ПериодыРегистрацийРегистра.РегистрацияВНалоговомОргане
			|
			|СГРУППИРОВАТЬ ПО
			|	ПериодыДействияРегистраций.СтруктурнаяЕдиница";
			
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				СтрокиСтруктурнойЕдиницы = ИсправляемыеРегистрации.НайтиСтроки(Новый Структура("СтруктурнаяЕдиница", Выборка.СтруктурнаяЕдиница));
				Если СтрокиСтруктурнойЕдиницы.Количество() = 0 Тогда
					ЗаполнитьЗначенияСвойств(ИсправляемыеРегистрации.Добавить(), Выборка);
				Иначе
					Если СтрокиСтруктурнойЕдиницы[0].Период > Выборка.Период Тогда
						СтрокиСтруктурнойЕдиницы[0].Период = Выборка.Период;
					КонецЕсли; 
				КонецЕсли; 
				
			КонецЦикла;
			
		КонецЕсли; 
		
		Запрос.Текст =
			"УНИЧТОЖИТЬ ВТПериодыРегистрацийРегистра";
			
		Запрос.Выполнить();
		
	КонецЦикла;
	
	ИсправляемыеРегистрации.Сортировать("СтруктурнаяЕдиница,Период");

КонецПроцедуры

&НаСервере
Процедура ИсправитьРегистрацииНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Обработки.ПерезаполнениеРегистрацийВНалоговомОргане.СоздатьВТПериодыДействияРегистраций(Запрос.МенеджерВременныхТаблиц);
	
	Для каждого СтрокаСтруктурнойЕдиницы Из ИсправляемыеРегистрации Цикл
		
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтрокаСтруктурнойЕдиницы.СтруктурнаяЕдиница);
		Запрос.УстановитьПараметр("Период", СтрокаСтруктурнойЕдиницы.Период);
		
		ОписанияРегистровСодержащихРегистрации = ЗарплатаКадры.ОписанияРегистровСодержащихРегистрацииВНалоговомОргане();
		Для каждого ОписаниеРегистра Из ОписанияРегистровСодержащихРегистрации Цикл
			
			Если Не ОписаниеРегистра.ЕстьПодразделения Тогда
				Продолжить;
			КонецЕсли;
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ИсследуемыйРегистр.Период КАК Период,
				|	ИсследуемыйРегистр.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
				|	ИсследуемыйРегистр.Подразделение КАК СтруктурнаяЕдиница,
				|	ИсследуемыйРегистр.Регистратор КАК Регистратор
				|ПОМЕСТИТЬ ВТПериодыРегистрацийРегистра
				|ИЗ
				|	&ИсследуемыйРегистр КАК ИсследуемыйРегистр
				|ГДЕ
				|	ИсследуемыйРегистр.Период >= &Период
				|	И ИсследуемыйРегистр.Подразделение = &СтруктурнаяЕдиница";
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсследуемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
			Запрос.Выполнить();
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ПериодыРегистрацийРегистра.Регистратор КАК Регистратор
				|ПОМЕСТИТЬ ВТИсправляемыеРегистраторы
				|ИЗ
				|	ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыРегистрацийРегистра КАК ПериодыРегистрацийРегистра
				|		ПО ПериодыДействияРегистраций.СтруктурнаяЕдиница = ПериодыРегистрацийРегистра.СтруктурнаяЕдиница
				|			И ПериодыДействияРегистраций.Период <= ПериодыРегистрацийРегистра.Период
				|			И (ПериодыДействияРегистраций.ПериодПоследующий > ПериодыРегистрацийРегистра.Период
				|				ИЛИ ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1))
				|			И ПериодыДействияРегистраций.РегистрацияВНалоговомОргане <> ПериодыРегистрацийРегистра.РегистрацияВНалоговомОргане";
			Запрос.Выполнить();
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ИсправляемыйРегистр.Регистратор КАК Регистратор,
				|	ПериодыДействияРегистраций.РегистрацияВНалоговомОргане,
				|	ИсправляемыйРегистр.*
				|ИЗ
				|	&ИсправляемыйРегистр КАК ИсправляемыйРегистр
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыДействияРегистраций КАК ПериодыДействияРегистраций
				|		ПО (ИсправляемыйРегистр.Подразделение = ПериодыДействияРегистраций.СтруктурнаяЕдиница)
				|			И (ПериодыДействияРегистраций.Период <= ИсправляемыйРегистр.Период)
				|			И (ПериодыДействияРегистраций.ПериодПоследующий > ИсправляемыйРегистр.Период ИЛИ ПериодыДействияРегистраций.ПериодПоследующий = ДАТАВРЕМЯ(1, 1, 1))
				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИсправляемыеРегистраторы КАК ИсправляемыеРегистраторы
				|		ПО ИсправляемыйРегистр.Регистратор = ИсправляемыеРегистраторы.Регистратор
				|ИТОГИ ПО
				|	Регистратор";
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсправляемыйРегистр", ОписаниеРегистра.ПолноеИмяРегистра);
			
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				
				ВыборкаРегистраторов = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаРегистраторов.Следующий() Цикл
					
					НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОписаниеРегистра.ПолноеИмяРегистра).СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистраторов.Регистратор);
					
					Выборка = ВыборкаРегистраторов.Выбрать();
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
					КонецЦикла;
					
					НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
					НаборЗаписей.ОбменДанными.Загрузка = Истина;
					НаборЗаписей.Записать();
					
				КонецЦикла;
				
				УстановитьПривилегированныйРежим(Ложь);
				
			КонецЕсли;
			
			Запрос.Текст =
				"УНИЧТОЖИТЬ ВТПериодыРегистрацийРегистра
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|УНИЧТОЖИТЬ ВТИсправляемыеРегистраторы";
				
			Запрос.Выполнить();
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПроверитьИсториюРегистрацийВНалоговомОрганеВФорме();
	
КонецПроцедуры

#КонецОбласти
