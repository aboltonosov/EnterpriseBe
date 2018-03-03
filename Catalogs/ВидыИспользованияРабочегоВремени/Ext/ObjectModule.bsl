﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИмяФОРаботаВБюджетномУчреждении = "РаботаВБюджетномУчреждении";
	Если ПолучитьФункциональнуюОпцию(ИмяФОРаботаВБюджетномУчреждении) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(БуквенныйКод) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("БуквенныйКод", БуквенныйКод);
		
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыИспользованияРабочегоВремени.Наименование,
		|	ВидыИспользованияРабочегоВремени.Ссылка
		|ИЗ
		|	Справочник.ВидыИспользованияРабочегоВремени КАК ВидыИспользованияРабочегоВремени
		|ГДЕ
		|	ВидыИспользованияРабочегоВремени.Ссылка <> &Ссылка
		|	И ВидыИспользованияРабочегоВремени.БуквенныйКод = &БуквенныйКод";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Буквенный код ""%1"" уже используется для вида времени: ""%2"".'"), БуквенныйКод, Выборка.Наименование);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БуквенныйКод", "Объект", Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли