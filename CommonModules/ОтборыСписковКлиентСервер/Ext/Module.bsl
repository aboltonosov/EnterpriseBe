﻿
#Область ПроцедурыОтбораПоАктуальности

// Устанавливает переданный в форму списка документов отбор по актуальности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
// ДатаСобытия - Дата - дата, на которую необходимо считать документы неактуальными
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//
Процедура ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Актуальность",   Актуальность);
		СтруктураБыстрогоОтбора.Свойство("ДатаСобытия",    ДатаСобытия);
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности, сохраненный в настройках
// Отбор из настроек устанавливается только если отбор не передан в форму извне
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
// ДатаСобытия - Дата - дата, на которую необходимо считать документы неактуальными
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
// Настройки - Соответствие - настройки формы
//
Процедура ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		Актуальность     = Настройки.Получить("Актуальность");
		ДатаСобытия      = Настройки.Получить("ДатаСобытия");
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
		
	Иначе
		
		Если Не СтруктураБыстрогоОтбора.Свойство("Актуальность") Тогда
			Актуальность = Настройки.Получить("Актуальность");
		КонецЕсли;
		
		Если Не СтруктураБыстрогоОтбора.Свойство("ДатаСобытия") Тогда
			ДатаСобытия = Настройки.Получить("ДатаСобытия");
		КонецЕсли;
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
		
	КонецЕсли;
	
	Настройки.Удалить("Актуальность");
	Настройки.Удалить("ДатаСобытия");
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
//
Процедура УстановитьОтборВСпискеПоАктуальности(Список, Актуальность) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
		"Просрочен",
		Актуальность = НСтр("ru='Просрочен'"),
		ВидСравненияКомпоновкиДанных.Равно,,
		Актуальность = НСтр("ru='Не просрочен'") ИЛИ Актуальность = НСтр("ru='Просрочен'"));
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по дате события
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// ДатаСобытия - Дата - дата, на которую документ будет просрочен
//
Процедура УстановитьОтборВСпискеПоДатеСобытия(Список, ДатаСобытия) Экспорт
	
	ВидСравненияДатыСобытия = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
		НСтр("ru='Отбор по дате события'"), 
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора,
		"ДатаСобытия",
		ВидСравненияДатыСобытия,
		ДатаСобытия,,
		ЗначениеЗаполнено(ДатаСобытия));
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора,
		"ДатаСобытия",
		ВидСравненияКомпоновкиДанных.НеРавно,
		Дата(1,1,1),,
		ЗначениеЗаполнено(ДатаСобытия));

КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности и дате актуальности
// Изменяет значение даты актуальности в зависимости от строки актуальности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
// ДатаСобытия - Дата - дата, на которую документы считаются неактуальными
//
Процедура ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия) Экспорт
	
	ВидСравненияДатыСобытия = ВидСравненияКомпоновкиДанных.Равно;
	
	Если НЕ ЗначениеЗаполнено(Актуальность) Тогда
		ДатаСобытия      = Дата(1,1,1);
	ИначеЕсли Актуальность = "Сегодня" Тогда
		ДатаСобытия = ТекущаяДата();
	ИначеЕсли Актуальность = "Завтра" Тогда
		ДатаСобытия = ТекущаяДата() + 86400;
	ИначеЕсли Актуальность = "Послезавтра" Тогда
		ДатаСобытия = ТекущаяДата() + 2*86400;
	ИначеЕсли Актуальность = "Через неделю" Тогда
		ДатаСобытия = ТекущаяДата() + 7*86400;	
	//Отрабатываем старые значения, из сохранившихся настроек
	ИначеЕсли Актуальность = "Все" 
		ИЛИ СтрНайти(Актуальность, "Истекающие на") > 0 Тогда
		Актуальность = "";
		ДатаСобытия      = Дата(1,1,1);
	ИначеЕсли Актуальность = "Просроченные" Тогда
		Актуальность = "Просрочен";
		ДатаСобытия      = Дата(1,1,1);
	ИначеЕсли Актуальность = "Не просроченные" Тогда
		Актуальность = "Не просрочен";
		ДатаСобытия      = Дата(1,1,1);
	КонецЕсли;
	
	УстановитьОтборВСпискеПоАктуальности(Список, Актуальность);
	УстановитьОтборВСпискеПоДатеСобытия(Список, ДатаСобытия);
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности и дате актуальности
// Изменяет значение даты актуальности в зависимости от строки актуальности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
// ДатаАктуальности - Дата - дата, на которую документы считаются неактуальными
// ДатаСобытия - Дата - дата, на которую документ будет просрочен
// СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки при очистке значения поля
//
Процедура ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Актуальность) Тогда
		Актуальность = "";
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);
	КонецЕсли;
	
КонецПроцедуры

//Заполняет список выбора для отбора по актуальности
//
// Параметры:
// 	СписокВыбораАктуальности - СписокВыбора - список выбора, который необходимо заполнить
//
Процедура ЗаполнитьСписокВыбораОтбораПоАктуальности(СписокВыбораАктуальности) Экспорт
	
	СписокВыбораАктуальности.Добавить("Не просрочен",     НСтр("ru='Не просрочен'"));
	СписокВыбораАктуальности.Добавить("Просрочен",        НСтр("ru='Просрочен'"));
	СписокВыбораАктуальности.Добавить("Истекает на дату", НСтр("ru='Истекает на дату...'"));
	СписокВыбораАктуальности.Добавить("Сегодня",          НСтр("ru='Сегодня'"));
	СписокВыбораАктуальности.Добавить("Завтра",           НСтр("ru='Завтра'"));
	СписокВыбораАктуальности.Добавить("Послезавтра",      НСтр("ru='Послезавтра'"));
	СписокВыбораАктуальности.Добавить("Через неделю",     НСтр("ru='Через неделю'"));
	
КонецПроцедуры

#КонецОбласти

// ФУНКЦИИ ОТБОРА ПО СОСТОЯНИЮ

// Проверяет передан ли в форму списка документов отбор по состоянию
//
// Параметры:
// Состояние - Строка - строка отбора по состоянию
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//
// Возвращаемое значение:
// Булево
// Истина, если необходимо установить отбор по состоянию, иначе Ложь
//
Функция НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("Состояние", Состояние) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // НеобходимОтборПоСостояниюПриСозданииНаСервере()

// Проверяет, нужно ли устанавливать отбор по состоянию, загруженный из настроек или переданный в форму извне
//
// Отбор из настройк устанавливается только если отбор не передан в форму извне
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Актуальность - Строка - строка отбора по актуальности
// ДатаАктуальности - Дата - дата, на которую необходимо считать документы неактуальными
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
// Настройки - Соответствие - настройки формы
//
Функция НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	НеобходимОтборПоСостоянию = Ложь;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		Состояние = Настройки.Получить("Состояние");
		НеобходимОтборПоСостоянию = Истина;
		
	Иначе
	
		Если Не СтруктураБыстрогоОтбора.Свойство("Состояние") Тогда
			Состояние = Настройки.Получить("Состояние");
			НеобходимОтборПоСостоянию = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Настройки.Удалить("Состояние");

	Возврат НеобходимОтборПоСостоянию;
	
КонецФункции // НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек()

// ПРОЦЕДУРЫ ОТБОРА ПО РЕГУЛЯРНОСТИ

// Устанавливает переданный в форму списка документов отбор по регулярности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Регулярность - Строка - строка отбора по регулярности
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//
Процедура ОтборПоРегулярностиПриСозданииНаСервере(Список, Регулярность, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбора.Свойство("Регулярность", Регулярность) Тогда
			УстановитьОтборВСпискеПоРегулярности(Список, Регулярность);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОтборПоРегулярностиПриСозданииНаСервере()

// Устанавливает в форме списка документов отбор по регулярности, сохраненный в настройках
// Отбор из настроек устанавливается только если отбор не передан в форму извне
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Регулярность - Строка - строка отбора по регулярности
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
// Настройки - Соответствие - настройки формы
//
Процедура ОтборПоРегулярностиПриЗагрузкеИзНастроек(Список, Регулярность, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		Регулярность = Настройки.Получить("Регулярность");
		УстановитьОтборВСпискеПоРегулярности(Список, Регулярность);
		
	Иначе
	
		Если Не СтруктураБыстрогоОтбора.Свойство("Регулярность") Тогда
			Регулярность = Настройки.Получить("Регулярность");
			УстановитьОтборВСпискеПоРегулярности(Список, Регулярность);
		КонецЕсли;
		
	КонецЕсли;
	
	Настройки.Удалить("Регулярность");
	
КонецПроцедуры // ОтборПоРегулярностиПриЗагрузкеИзНастроек()

// Устанавливает в форме списка документов отбор по регулярности
//
// Параметры:
// Список - ДинамическийСписок - список, в котором необходимо установить отбор
// Регулярность - Строка - строка отбора по регулярности
//
Процедура УстановитьОтборВСпискеПоРегулярности(Список, Регулярность) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Регулярное", Регулярность = "Регулярные", ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(Регулярность));
	
КонецПроцедуры // УстановитьОтборВСпискеПоРегулярности()

// ПРОЦЕДУРЫ ОТБОРА ПО ЗНАЧЕНИЮ СПИСКОВ

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора
//
// Параметры:
//  Список - динамический список, для которого требуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора, 
			Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбора.Свойство(ИмяКолонки, Значение) Тогда
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОтборПоЗначениюСпискаПриСозданииНаСервере()

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора и переданных настроек
//
// Параметры:
//  Список - динамический список, для которого треюуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Настройки - настройки, из которых могут получаться значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора, 
			Настройки, Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		Значение = Настройки.Получить(ИмяКолонки);
		Если ПриводитьЗначениеКЧислу Тогда
			Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
		КонецЕсли;
		ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
	Иначе
		Если Не СтруктураБыстрогоОтбора.Свойство(ИмяКолонки) Тогда
			Значение = Настройки.Получить(ИмяКолонки);
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Удалить(ИмяКолонки);
	
КонецПроцедуры

// Устанавливает отборы в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора и переданных настроек
//
// Параметры:
//	ПараметрыОтбора - Структура - Структура параметров отбора, включающая следующие поля:
//  	*ФормаСписка - УправляемаяФорма - Форма, на которой находятся динамические списки
//  	*МассивСписков - Массив - массив названий динамических списков, для которого треюуется установить отбор
//  	*ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  	*Значение - устанавливаемое значение отбора
//  	*Настройки - настройки, из которых могут получаться значения отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//
Процедура УстановитьОтборыПоЗначениюСпискаПриЗагрузкеИзНастроек(ПараметрыОтбора, Знач СтруктураБыстрогоОтбора, Использование = Неопределено, ВидСравнения = Неопределено) Экспорт
	
	ФормаСписка     = ПараметрыОтбора.ФормаСписка;
	МассивСписков 	= ПараметрыОтбора.МассивСписков;
	ИмяКолонки  	= ПараметрыОтбора.ИмяКолонки;
	Значение        = ПараметрыОтбора.Значение;
	Настройки       = ПараметрыОтбора.Настройки;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		Значение = Настройки.Получить(ИмяКолонки);
		ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		Для каждого Список Из МассивСписков Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ФормаСписка[Список], 
				ИмяКолонки,
				Значение,
				ВидСравнения,,
				ИспользованиеЭлементаОтбора);
		КонецЦикла;
	Иначе
		Если Не СтруктураБыстрогоОтбора.Свойство(ИмяКолонки) Тогда
			Значение = Настройки.Получить(ИмяКолонки);
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			Для каждого Список Из МассивСписков Цикл
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ФормаСписка[Список],
					ИмяКолонки, 
					Значение, 
					ВидСравнения,,
					ИспользованиеЭлементаОтбора);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Удалить(ИмяКолонки);
	
КонецПроцедуры
// ПРОЦЕДУРЫ И ФУНКЦИИ ОТБОРА ПО МЕНЕДЖЕРУ

// Процедура копирует в список выбора поля отбора значения из списка источника
//
Процедура СкопироватьСписокВыбораОтбораПоМенеджеру(СписокВыбора, СписокИсточник) Экспорт
	
	СписокВыбора.Очистить();
	Для Итератор = 0 По СписокИсточник.Количество() - 1 Цикл
		СписокВыбора.Добавить(СписокИсточник[Итератор].Значение, СписокИсточник[Итератор].Представление);
	КонецЦикла;
	
КонецПроцедуры // СкопироватьСписокВыбораОтбораПоМенеджеру()



//////////////////////////////
// БРУ

Процедура УстановитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено, Представление = "")
	
	ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ЭлементОтбора.ВидСравнения     = ?(ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно, ВидСравнения);
	ЭлементОтбора.Использование    = Истина;
	ЭлементОтбора.ПравоеЗначение   = ПравоеЗначение;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Представление    = Представление;
	
КонецПроцедуры // УстановитьЭлементОтбораКоллекции()

Процедура УдалитьЭлементОтбораКоллекции(КоллекцияЭлементов, ИмяПоля)
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			КоллекцияЭлементов.Удалить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораСписка()

Процедура ИзменитьЭлементОтбораГруппыСписка(Группа, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено) Экспорт
	
	УдалитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля);
	
	Если Установить Тогда
		УстановитьЭлементОтбораКоллекции(Группа.Элементы, ИмяПоля, ПравоеЗначение, ВидСравнения);
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЭлементОтбораСписка()

Функция НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление, ВидПоиска = 0) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ВидПоиска = 0 Тогда
			Если ЭлементОтбора.Представление = Представление Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 1 Тогда
			Если СтрНайти(ЭлементОтбора.Представление, Представление) = 1 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		ИначеЕсли ВидПоиска = 2 Тогда
			Если СтрНайти(ЭлементОтбора.Представление, Представление) > 0 Тогда
				ВозвращаемоеЗначение = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции // НайтиЭлементОтбораПоПредставлению()

Функция СоздатьГруппуЭлементовОтбора(КоллекцияЭлементов, Представление, ТипГруппы) Экспорт
	
	ГруппаЭлементовОтбора = НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление);
	Если ГруппаЭлементовОтбора = Неопределено Тогда
		ГруппаЭлементовОтбора = КоллекцияЭлементов.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	Иначе
		ГруппаЭлементовОтбора.Элементы.Очистить();
	КонецЕсли;
	
	ГруппаЭлементовОтбора.Представление    = Представление;
	ГруппаЭлементовОтбора.Применение       = ТипПримененияОтбораКомпоновкиДанных.Элементы;
	ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ГруппаЭлементовОтбора.ТипГруппы        = ТипГруппы;
	ГруппаЭлементовОтбора.Использование    = Истина;
	
	Возврат ГруппаЭлементовОтбора;
	
КонецФункции


//Удаляет элемент отбора динамического списка
//
//Параметры:
//Список  - обрабатываемый динамический список,
//ИмяПоля - имя поля компоновки, отбор по которому нужно удалить
//
Процедура УдалитьЭлементОтбораСписка(Список, ИмяПоля) Экспорт
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;
	
КонецПроцедуры // УдалитьЭлементОтбораСписка()

// Устанавливает элемент отбор динамического списка
//
//Параметры:
//Список			- обрабатываемый динамический список,
//ИмяПоля			- имя поля компоновки, отбор по которому нужно установить,
//ВидСравнения		- вид сравнения отбора, по умолчанию - Равно,
//ПравоеЗначение 	- значение отбора
//
Процедура УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения = Неопределено, Представление = "") Экспорт
	
	УстановитьЭлементОтбораКоллекции(ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы, ИмяПоля, ПравоеЗначение, ВидСравнения, Представление);
	
КонецПроцедуры // УстановитьЭлементОтбораСписка()

//Изменяет элемент отбора динамического списка
//
//Параметры:
//Список         - обрабатываемый динамический список,
//ИмяПоля        - имя поля компоновки, отбор по которому нужно установить,
//ВидСравнения   - вид сравнения отбора, по умолчанию - Равно,
//ПравоеЗначение - значение отбора,
//Установить     - признак необходимости установить отбор
//
Процедура ИзменитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение = Неопределено, Установить = Ложь, ВидСравнения = Неопределено) Экспорт
	
	УдалитьЭлементОтбораСписка(Список, ИмяПоля);
	
	Если Установить Тогда
		УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, ВидСравнения);
	КонецЕсли;
	
КонецПроцедуры // ИзменитьЭлементОтбораСписка()
