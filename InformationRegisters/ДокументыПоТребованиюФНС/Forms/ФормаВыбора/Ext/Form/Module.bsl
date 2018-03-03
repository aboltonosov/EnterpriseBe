﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПереопределитьТекстЗапросаДинамическогоСписка(Список);
	
	ЗаполнитьСпискиВыбора();
	ПодготовитьОтборПоПериоду(Список.Отбор);
	ПодготовитьОтборПоКонтрагенту(Список.Отбор);
	
	Если НЕ ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен() Тогда
		Элементы.ОтборКонтрагентПредставление.КнопкаВыбора = Ложь;
		Элементы.ОтборКонтрагентПредставление.ПодсказкаВвода = "Введите ИНН контрагента";
	КонецЕсли;
	
	
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	//установим предварительные отборы по параметрам
	УстановитьОтборыДляРежимаВыбора();
	
	
	//выбирать готовые к отправке документы не имеет смысла
	УстановитьОтборСписка(Список.Отбор, "Готовность", Ложь); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если СтрНайти(ИмяСобытия, "Запись_") > 0 Тогда
		
		ОбновитьСписокНаСервере();	
		
		Если ЗначениеЗаполнено(ОтборКонтрагент) ИЛИ ЗначениеЗаполнено(ОтборКонтрагентИНН) Тогда
			Если ЗначениеЗаполнено(ОтборКонтрагент) Тогда
				
				ОтбработатьВыборКонтрагентаНаСервере(ОтборКонтрагент)	
				
			ИначеЕсли ЗначениеЗаполнено(ОтборКонтрагентИНН) Тогда
				
				ОтбработатьИзменениеИННКонтрагента(ОтборКонтрагентИНН);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	СписокОтбор = Список.Отбор;
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		
		УстановитьОтборСписка(СписокОтбор, "Организация", ОтборОрганизация); 
		
	Иначе
		
		ОтключитьОтборСписка(СписокОтбор, "Организация"); 
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборВидДокументаФНСПриИзменении(Элемент)
	
	СписокОтбор = Список.Отбор;
	
	Если ЗначениеЗаполнено(ОтборВидДокументаФНС) Тогда
		
		ВидСравненияОтбора = Неопределено;
		
		Если ОтборВидДокументаФНС = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.Договор") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
 	        ОтборПоВидуДокументаФНС = Новый Массив;
		    ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.Договор"));
			ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ДополнениеКДоговору"));
			ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.СпецификацияЦены"));
	    ИначеЕсли ОтборВидДокументаФНС = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
 	        ОтборПоВидуДокументаФНС = Новый Массив;
		    ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация"));
			ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ДобавочныйЛистГрузовойТаможеннойДекларации"));
		 ИначеЕсли ОтборВидДокументаФНС = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.СчетФактура") Тогда
			ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
 	        ОтборПоВидуДокументаФНС = Новый Массив;
		    ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.СчетФактура"));
			ОтборПоВидуДокументаФНС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура"));
		Иначе
			ОтборПоВидуДокументаФНС = ОтборВидДокументаФНС;
		КонецЕсли;

		УстановитьОтборСписка(СписокОтбор, "ВидДокументаФНС", ОтборПоВидуДокументаФНС, ВидСравненияОтбора); 
		
	Иначе
		
		ОтключитьОтборСписка(СписокОтбор, "ВидДокументаФНС"); 
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборНаправлениеПриИзменении(Элемент)

	СписокОтбор = Список.Отбор;
	
	Если ЗначениеЗаполнено(ОтборНаправление) Тогда
		Если ОтборНаправление = ПредопределенноеЗначение("Перечисление.НаправленияДокументаПоТребованиюФНС.Получен") Тогда
			ОтборНаправлениеЧисло = 1;
		ИначеЕсли ОтборНаправление = ПредопределенноеЗначение("Перечисление.НаправленияДокументаПоТребованиюФНС.Выдан") Тогда
			ОтборНаправлениеЧисло = 2;
		КонецЕсли;
		
		УстановитьОтборСписка(СписокОтбор, "Направление", ОтборНаправлениеЧисло); 
		
	Иначе
		ОтключитьОтборСписка(СписокОтбор, "Направление"); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаКонцаПериодаОтчетаПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(Список.Отбор, ДатаНачалаПериода, ДатаКонцаПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(Список.Отбор, ДатаНачалаПериода, ДатаКонцаПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыборКонтрагентаЗавершение", ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",ДополнительныеПараметры, ЭтаФорма,,,,
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ИНН = ПолучитьИННИзСтроки(Текст);
	Если ЗначениеЗаполнено(ИНН) Тогда
		
		ОтборКонтрагентПредставление = ИНН + " (ИНН)";
		ОтборКонтрагент = Неопределено;
		ОтборКонтрагентИНН = ИНН;
		
	Иначе
		
		ОтборКонтрагентПредставление = "";
		ОтборКонтрагентИНН = "";
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПредставлениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ОтборКонтрагентИНН) Тогда
		//введен вручную ИНН
		ОтбработатьИзменениеИННКонтрагента(ОтборКонтрагентИНН);
		
	Иначе
		//поле очищено
		УстановитьОтборПоКонтрагенту(Список.Отбор, Неопределено, Неопределено);	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборКонтрагент = Неопределено;
	ОтборКонтрагентИНН = "";
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьИсточникПоТекущейСтроке();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	//откроем источник
	Если ЗначениеЗаполнено(ТекущиеДанные.Источник) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Источник);	
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ОтборКонтрагент) Тогда
		ПоказатьЗначение(, ОтборКонтрагент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПроизвольныйПериод(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = ДатаНачалаПериода;
	Диалог.Период.ДатаОкончания = ДатаКонцаПериода;
	
	ДополнительныеПараметры = Новый Структура("Диалог", Диалог);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПроизвольныйПериодЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ВыбратьИсточникПоТекущейСтроке();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры  

&НаСервере
Процедура ПереопределитьТекстЗапросаДинамическогоСписка(ДинСписок)
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен() Тогда
		ДинСписок.ТекстЗапроса = СтрЗаменить(ДинСписок.ТекстЗапроса, 
		"РегистрСведенийДокументыПоТребованиюФНС.КонтрагентПредставление",
		"ВЫБОР
		|	КОГДА РегистрСведенийДокументыПоТребованиюФНС.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|		ТОГДА РегистрСведенийДокументыПоТребованиюФНС.КонтрагентПредставление
		|	ИНАЧЕ РегистрСведенийДокументыПоТребованиюФНС.Контрагент
		|КОНЕЦ КАК КонтрагентПредставление");	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПроизвольныйПериодЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если Период <> Неопределено Тогда
		
		ДатаНачалаПериода = Диалог.Период.ДатаНачала;
		ДатаКонцаПериода  = Диалог.Период.ДатаОкончания;
	
		УстановитьОтборПоПериоду(Список.Отбор, ДатаНачалаПериода, ДатаКонцаПериода);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКонтрагентаЗавершение(РезультатВыбора, Параметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;   

	ОтборКонтрагент = РезультатВыбора;
	ОтборКонтрагентИНН = "";	
	
	ОтбработатьВыборКонтрагентаНаСервере(ОтборКонтрагент);

КонецПроцедуры

&НаСервере
Процедура ОтбработатьВыборКонтрагентаНаСервере(Контрагент)
	
	//определяем реквизиты контрагента по ссылке
	РеквизитыКонтрагента = Новый Структура;
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганами.РеквизитыСправочникаКонтрагентовДоступны() Тогда
		//наличие всех реквизитов предварительно проверяется
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Представление,
		|	Контрагенты.ИНН,
		|	Контрагенты.КПП
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &КонтрагентСсылка";
		
		Запрос.УстановитьПараметр("КонтрагентСсылка", Контрагент);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			РеквизитыКонтрагента.Вставить("ИНН", 			Выборка.ИНН);
			РеквизитыКонтрагента.Вставить("КПП", 			Выборка.КПП);
			РеквизитыКонтрагента.Вставить("Представление", 	Выборка.Представление);
			
		КонецЕсли;	
		
	Иначе
		
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьРеквизитыКонтрагента(Контрагент, РеквизитыКонтрагента);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(РеквизитыКонтрагента) Тогда
		
		КонтрагентИНН 					= РеквизитыКонтрагента.ИНН; 
		КонтрагентКПП 					= РеквизитыКонтрагента.КПП;
		ОтборКонтрагентПредставление 	= РеквизитыКонтрагента.Представление;	//заполним реквизит формы
		
		//найдем сканированные документы по ИНН и КПП контрагента
		МассивСканированныхДокументов = ПолучитьСканированныеДокументыПоИННКПП(КонтрагентИНН, КонтрагентКПП);
		
		МассивКонтрагентов = Новый Массив;
		МассивКонтрагентов.Добавить(Контрагент);
		
		УстановитьОтборПоКонтрагенту(Список.Отбор, МассивКонтрагентов, МассивСканированныхДокументов);	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
 Процедура ОтбработатьИзменениеИННКонтрагента(КонтрагентИНН)
	
	 МассивКонтрагентов = Новый Массив;
	 
	 Если ЭлектронныйДокументооборотСКонтролирующимиОрганами.РеквизитыСправочникаКонтрагентовДоступны() Тогда
		 
		 Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ИНН = &ОтборИНН";
		
		Запрос.УстановитьПараметр("ОтборИНН", КонтрагентИНН);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			МассивКонтрагентов.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	 Иначе
		 
		 ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьМассивКонтрагентовПоИНН(КонтрагентИНН, МассивКонтрагентов);
		 
	 КонецЕсли;
	 
	//найдем сканированные документы по ИНН контрагента
	МассивСканированныхДокументов = ПолучитьСканированныеДокументыПоИННКПП(КонтрагентИНН);
	
	УстановитьОтборПоКонтрагенту(Список.Отбор, МассивКонтрагентов, МассивСканированныхДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИсточникПоТекущейСтроке()
	
	//следует передать вызвавшей форме данные по источнику, номеру строки источника и виду документа ФНС
	//лишь полная их совокупность однозначно определяет параметры для заполнения реквизитов сканированного документа
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыИсточника = Новый Структура;
		ПараметрыИсточника.Вставить("Источник", 			ТекущиеДанные.Источник);
		ПараметрыИсточника.Вставить("ВидДокументаФНС", 		ТекущиеДанные.ВидДокументаФНС);
		ПараметрыИсточника.Вставить("НомерСтрокиИсточника", ТекущиеДанные.НомерСтрокиИсточника);
		
		ОповеститьОВыборе(ПараметрыИсточника);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДляРежимаВыбора()
	
	Если ЗначениеЗаполнено(Параметры.ОтборОрганизация) Тогда
		ОтборОрганизация 		= Параметры.ОтборОрганизация;
		УстановитьОтборСписка(Список.Отбор, "Организация", ОтборОрганизация); 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОтборНаправление) Тогда
		ОтборНаправление 		= Параметры.ОтборНаправление;
		
		Если ОтборНаправление = ПредопределенноеЗначение("Перечисление.НаправленияДокументаПоТребованиюФНС.Получен") Тогда
			ОтборНаправлениеЧисло = 1;
		ИначеЕсли ОтборНаправление = ПредопределенноеЗначение("Перечисление.НаправленияДокументаПоТребованиюФНС.Выдан") Тогда
			ОтборНаправлениеЧисло = 2;
		КонецЕсли;
		
		УстановитьОтборСписка(Список.Отбор, "Направление", ОтборНаправлениеЧисло); 
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОтборВидДокументаФНС) Тогда
		
		Если Параметры.ОтборВидДокументаФНС = Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура Тогда
			ОтборВидДокументаФНС 	= Перечисления.ВидыПредставляемыхДокументов.СчетФактура;
		ИначеЕсли Параметры.ОтборВидДокументаФНС = Перечисления.ВидыПредставляемыхДокументов.ДобавочныйЛистГрузовойТаможеннойДекларации Тогда
			ОтборВидДокументаФНС 	= Перечисления.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация;
		ИначеЕсли Параметры.ОтборВидДокументаФНС = Перечисления.ВидыПредставляемыхДокументов.ДополнениеКДоговору
			ИЛИ Параметры.ОтборВидДокументаФНС = Перечисления.ВидыПредставляемыхДокументов.СпецификацияЦены Тогда
			ОтборВидДокументаФНС 	= Перечисления.ВидыПредставляемыхДокументов.Договор;
		Иначе
			ОтборВидДокументаФНС 	= Параметры.ОтборВидДокументаФНС;
		КонецЕсли;
		
		УстановитьОтборСписка(Список.Отбор, "ВидДокументаФНС", ОтборВидДокументаФНС); 
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	//ОтборВидДокументаФНС
	СписокВыбораВидДокументаФНС = Элементы.ОтборВидДокументаФНС.СписокВыбора; 
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.СчетФактура);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ТоварноТранспортнаяНакладная);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.Договор);        
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ОтчетНИОКР);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ПередачаТоваров);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.ПередачаУслуг);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.УПД);
	СписокВыбораВидДокументаФНС.Добавить(Перечисления.ВидыПредставляемыхДокументов.УКД);

	//ОтборНаправление
	СписокВыбораНаправление = Элементы.ОтборНаправление.СписокВыбора;
	СписокВыбораНаправление.Добавить(Перечисления.НаправленияДокументаПоТребованиюФНС.Выдан);
	СписокВыбораНаправление.Добавить(Перечисления.НаправленияДокументаПоТребованиюФНС.Получен);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПодготовитьОтборПоКонтрагенту(ОтборСписка)
	
	//добавим группу
	ГруппаОтбораИЛИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтборСписка.Элементы, Неопределено, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ЭлементОтбораКонтрагентСсылка = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораКонтрагентСсылка.ЛевоеЗначение 		= Новый ПолеКомпоновкиДанных("Контрагент");
	ЭлементОтбораКонтрагентСсылка.Представление 		= "Контрагент";
	ЭлементОтбораКонтрагентСсылка.Использование 		= Ложь;
	
	ЭлементОтбораСканированныйДокумент = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораСканированныйДокумент.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("СканированныйДокумент");
	ЭлементОтбораСканированныйДокумент.Представление 	= "СканированныйДокумент";
	ЭлементОтбораСканированныйДокумент.Использование 	= Ложь;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПодготовитьОтборПоПериоду(ОтборСписка)
	
	//добавим группу
	ГруппаОтбораИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ОтборСписка.Элементы, Неопределено, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);

	ОтборДатаНачала = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаНачала.ЛевоеЗначение 		= Новый ПолеКомпоновкиДанных("ДатаДокумента");
	ОтборДатаНачала.ВидСравнения 		= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборДатаНачала.Представление 		= "ДатаНачала";
	ОтборДатаНачала.Использование 		= Ложь;
	
	ОтборДатаОкончания = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаОкончания.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ДатаДокумента");
	ОтборДатаОкончания.ВидСравнения 	= ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборДатаОкончания.Представление 	= "ДатаОкончания";
	ОтборДатаОкончания.Использование 	= Ложь;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(ОтборСписка, ИмяПоля, ПравоеЗначение, ВидСравненияОтбора = Неопределено)
	
	Если ВидСравненияОтбора = Неопределено Тогда
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;

	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, ИмяПоля);
	Если МассивЭлементов.Количество() = 0 Тогда
		ЭлементОтбора = ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ОтборСписка, ИмяПоля, ВидСравненияОтбора);
	Иначе    
		ЭлементОтбора = МассивЭлементов[0];	
	КонецЕсли;
	
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ВидСравнения = ВидСравненияОтбора;
	ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтключитьОтборСписка(ОтборСписка, СтрокаЛевоеЗначение)
	
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(ОтборСписка, СтрокаЛевоеЗначение, , , , Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(ОтборСписка, НачалоПериода, КонецПериода)
	
	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, , "ДатаНачала");
	ОтборДатаНачала = МассивЭлементов[0];
	
	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, , "ДатаОкончания");
	ОтборДатаОкончания = МассивЭлементов[0];
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		ОтборДатаНачала.Использование = Истина;
		ОтборДатаНачала.ПравоеЗначение = НачалоДня(НачалоПериода);
	Иначе
		ОтборДатаНачала.Использование = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		ОтборДатаОкончания.Использование = Истина;
		ОтборДатаОкончания.ПравоеЗначение = КонецДня(КонецПериода);
	Иначе
		ОтборДатаОкончания.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоКонтрагенту(ОтборСписка, МассивКонтрагентов, МассивСканированныхДокументов)
	
	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, , "Контрагент");
	ОтборКонтрагент = МассивЭлементов[0];
	
	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОтборСписка, , "СканированныйДокумент");
	ОтборСканированныйДокумент = МассивЭлементов[0];
	
	Если МассивКонтрагентов <> Неопределено Тогда
		// в том числе, если массив - пустой
		
		ОтборКонтрагент.Использование = Истина;
		
		Если МассивКонтрагентов.Количество() = 1 Тогда
			//всего один контрагент в массиве, вид сравнения Равно
			ОтборКонтрагент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборКонтрагент.ПравоеЗначение = МассивКонтрагентов[0];
		Иначе
			//много контрагентов в массиве, вид сравнения ВСписке
			ОтборКонтрагент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ОтборКонтрагент.ПравоеЗначение = МассивКонтрагентов;
		КонецЕсли;
		
	Иначе
		// не нужно накладывать отбор
		ОтборКонтрагент.Использование = Ложь;
		
	КонецЕсли;
	
	Если МассивСканированныхДокументов <> Неопределено Тогда
		// в том числе, если массив - пустой
		
		ОтборСканированныйДокумент.Использование = Истина;
		
		Если МассивСканированныхДокументов.Количество() = 1 Тогда
			//всего один сканированный документ в массиве, вид сравнения Равно
			ОтборСканированныйДокумент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборСканированныйДокумент.ПравоеЗначение = МассивСканированныхДокументов[0];
		Иначе
			//много сканированных документов в массиве, вид сравнения ВСписке
			ОтборСканированныйДокумент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ОтборСканированныйДокумент.ПравоеЗначение = МассивСканированныхДокументов;
		КонецЕсли;
		
	Иначе
		// не нужно накладывать отбор
		ОтборСканированныйДокумент.Использование = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСканированныеДокументыПоИННКПП(ОтборИНН, ОтборКПП = "")
	
	МассивСканированныхДокументов = Новый Массив;
	
	Запрос = Новый Запрос;
	
	Если СтрДлина(ОтборИНН) = 10 Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка
		|ИЗ
		|	Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.РеквизитыУчастников КАК СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников
		|ГДЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЮрЛицоИНН = &ЮрЛицоИНН";
		
		Если ЗначениеЗаполнено(ОтборКПП) Тогда
		    Запрос.Текст = Запрос.Текст + "
				|	И СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ЮрЛицоКПП = &ЮрЛицоКПП";
			Запрос.УстановитьПараметр("ЮрЛицоКПП", ОтборКПП);
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ЮрЛицоИНН", ОтборИНН);
		
	ИначеЕсли СтрДлина(ОтборИНН) = 12 Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.Ссылка
		|ИЗ
		|	Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.РеквизитыУчастников КАК СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников
		|ГДЕ
		|	СканированныеДокументыДляПередачиВЭлектронномВидеРеквизитыУчастников.ФизЛицоИНН = &ФизЛицоИНН";
		
		Запрос.УстановитьПараметр("ФизЛицоИНН", ОтборИНН);
		
	Иначе
		
		Возврат МассивСканированныхДокументов;
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивСканированныхДокументов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат МассивСканированныхДокументов;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИННИзСтроки(ИННСтрока)
	
	КодПоиска = СокрЛП(ИННСтрока);
	
	КодПоискаТолькоЦифры = "";
	Для Индекс = 1 По СтрДлина(КодПоиска) Цикл
		Символ = Сред(КодПоиска, Индекс, 1);
		Если Не ЗначениеЗаполнено(Символ) Тогда
			Продолжить;
		КонецЕсли;
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ,, Ложь) Тогда
			КодПоискаТолькоЦифры = КодПоискаТолькоЦифры + Символ;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ДлинаСтроки = СтрДлина(КодПоискаТолькоЦифры);
	СтрокаПодсказки = "";
	
	Если ДлинаСтроки = 10 ИЛИ ДлинаСтроки = 12 Тогда
		Возврат КодПоискаТолькоЦифры;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти
