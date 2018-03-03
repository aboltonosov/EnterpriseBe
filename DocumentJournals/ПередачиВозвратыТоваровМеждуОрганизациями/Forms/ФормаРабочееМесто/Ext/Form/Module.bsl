﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	УстановитьПараметрыДинамическихСписков();
	УправлениеЭлементамиФормы();
	
	// Подсистема "ЭлектронныеДокументы"
	УстановитьВидимостьДоступность();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);

	Если Не ПроверкаКонтрагентовВызовСервераПовтИсп.ИспользованиеПроверкиВозможно() Тогда
		Элементы.СписокЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	Элементы.КОформлениюЗаПериодСклад.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(ПодключаемоеОборудованиеУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если (ИмяСобытия = "Запись_ПередачаТоваровМеждуОрганизациями" Или ИмяСобытия = "Запись_ВозвратТоваровМеждуОрганизациями")
		И Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению
	Тогда
		УправлениеЭлементамиФормы();
		Элементы.КОформлению.Обновить();
		Элементы.КОформлениюЗаПериод.Обновить();
	КонецЕсли;
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" ИЛИ ИмяСобытия = "ПолученыНовыеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОформленияПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"ЖурналДокументов.ПередачиВозвратыТоваровМеждуОрганизациями.ФормаРабочееМесто.Элемент.Страницы.ПриСменеСтраницы");
	
	Если ТекущаяСтраница = Элементы.СтраницаКОформлению Тогда
		УправлениеЭлементамиФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписков

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеПечатьюКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВозвратПоКомиссии(Команда)
	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями");
	
	СтруктураПараметры = Новый Структура();
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));

	ОткрытьФорму("Документ.ВозвратТоваровМеждуОрганизациями.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратТоваров(Команда)
	ОткрытьФорму("Документ.ВозвратТоваровМеждуОрганизациями.ФормаОбъекта", Неопределено, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПередачуНаКомиссию(Команда)
	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию");
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	
	ОткрытьФорму("Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта", ПараметрыФормы, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПередачуТоваров(Команда)
	ОткрытьФорму("Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта", Неопределено, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"ЖурналДокументов.ПередачиВозвратыТоваровМеждуОрганизациями.ФормаРабочееМесто.Команда.СоздатьДокумент");
	
	Строка = Элементы.КОформлению.ТекущиеДанные;
	
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("Организация",				Строка.Отправитель);
		СтруктураОснование.Вставить("ОрганизацияПолучатель",	Строка.Получатель);
		СтруктураОснование.Вставить("Склад",					Строка.Склад);
		СтруктураОснование.Вставить("ПередачаПодДеятельность",	Строка.ПередачаПодДеятельность);
		СтруктураОснование.Вставить("ТипЗапасов",				Строка.ТипЗапасов);
		СтруктураОснование.Вставить("НачалоПериода",			Строка.ДатаОформления);
		СтруктураОснование.Вставить("КонецПериода",				Строка.ДатаПоследнейПродажи);
		СтруктураОснование.Вставить("ЗаполнятьПоСхеме",			Истина);
		СтруктураОснование.Вставить("ХозяйственнаяОперация",	Строка.ХозяйственнаяОперация);
		СтруктураОснование.Вставить("ДатаОформления",			Строка.ДатаОформления);
		СтруктураОснование.Вставить("Договор",					Строка.Договор);
		СтруктураОснование.Вставить("ВидЦены",					Строка.ВидЦены);
		
		ПараметрыОткрытия = Новый Структура("Основание", СтруктураОснование);
		
		Если    Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию")
			Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию")
		Тогда
			ИмяФормыОткрытия = "Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта";
		ИначеЕсли Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями")
			  Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями")
		Тогда
			СтруктураОснование.НачалоПериода = Период.ДатаНачала;
			СтруктураОснование.КонецПериода = Период.ДатаОкончания;
			ИмяФормыОткрытия = "Документ.ВозвратТоваровМеждуОрганизациями.ФормаОбъекта"
		КонецЕсли;
		
		ОткрытьФорму(ИмяФормыОткрытия, ПараметрыОткрытия, Элементы.Список);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументЗаПериод(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"ЖурналДокументов.ПередачиВозвратыТоваровМеждуОрганизациями.ФормаРабочееМесто.Команда.СоздатьДокументЗаПериод");
	
	Строка = Элементы.КОформлениюЗаПериод.ТекущиеДанные;
	
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура;
		СтруктураОснование.Вставить("Организация",				Строка.Отправитель);
		СтруктураОснование.Вставить("ОрганизацияПолучатель",	Строка.Получатель);
		СтруктураОснование.Вставить("Склад",					Строка.Склад);
		СтруктураОснование.Вставить("ПередачаПодДеятельность",	Строка.ПередачаПодДеятельность);
		СтруктураОснование.Вставить("ТипЗапасов",				Строка.ТипЗапасов);
		СтруктураОснование.Вставить("НачалоПериода",			?(ЗначениеЗаполнено(Строка.Месяц), НачалоМесяца(Строка.Месяц), Период.ДатаНачала));
		СтруктураОснование.Вставить("КонецПериода",				?(ЗначениеЗаполнено(Строка.Месяц), КонецМесяца(Строка.Месяц), Период.ДатаОкончания));
		СтруктураОснование.Вставить("ЗаполнятьПоСхеме",			Истина);
		СтруктураОснование.Вставить("ХозяйственнаяОперация",	Строка.ХозяйственнаяОперация);
		СтруктураОснование.Вставить("ДатаОформления",			Неопределено);
		СтруктураОснование.Вставить("Договор",					Строка.Договор);
		СтруктураОснование.Вставить("ВидЦены",					Строка.ВидЦены);
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		
		Если    Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию")
			Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию")
		Тогда
			ОткрытьФорму("Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		ИначеЕсли Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями")
			  Или Строка.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями")
		Тогда
			ОткрытьФорму("Документ.ВозвратТоваровМеждуОрганизациями.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКОформлению(Команда)
	УправлениеЭлементамиФормы();
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УправлениеПечатьюКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ВариантОформления = 1 Тогда
		ЗаполнитьКОформлению();
		Элементы.ГруппаКОформлению.ТекущаяСтраница = Элементы.СтраницаПоДням;
	Иначе
		УстановитьПараметрыДинамическихСписков();
		Элементы.ГруппаКОформлению.ТекущаяСтраница = Элементы.СтраницаЗаПериод;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	НачалоПериода = НачалоДня(?(ЗначениеЗаполнено(Период.ДатаНачала), Период.ДатаНачала, '00010101'));
	КонецПериода = КонецДня(?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, '39991231'));
	
	Если НачалоПериода > КонецПериода Тогда
		ВызватьИсключение НСтр("ru = 'Дата начала периода не может быть больше даты окончания периода'");
	КонецЕсли;
	
	КОформлениюЗаПериод.Параметры.УстановитьЗначениеПараметра("НачГраница", Новый Граница(НачалоПериода, ВидГраницы.Включая));
	КОформлениюЗаПериод.Параметры.УстановитьЗначениеПараметра("КонГраница", Новый Граница(КонецПериода, ВидГраницы.Включая));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКОформлению()
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Потребления.ДатаОформления,
		|	Потребления.Отправитель,
		|	Потребления.Получатель,
		|	Потребления.АналитикаУчетаНоменклатуры, 
		|	Потребления.Склад,
		|	Потребления.Период,
		|	Потребления.ВидЗапасов,
		|	Потребления.ВидЗапасовПолучателя,
		|	Потребления.ТипЗапасов,
		|	Потребления.НалогообложениеНДС,
		|	Потребления.НомерГТД,
		|	Потребления.Потреблено
		|ПОМЕСТИТЬ Потребления
		|ИЗ &ТоварыКПередаче КАК Потребления
		|;
		|
		|ВЫБРАТЬ
		|	(ВЫБОР Потребления.ТипЗапасов
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию) КОНЕЦ) КАК ХозяйственнаяОперация,
		|	Потребления.ДатаОформления,
		|	Потребления.Отправитель,
		|	Потребления.Получатель,
		|	Потребления.Склад,
		|	Потребления.ТипЗапасов,
		|	Потребления.НалогообложениеНДС КАК ПередачаПодДеятельность,
		|	МАКСИМУМ(Потребления.Период) КАК ДатаПоследнейПродажи,
		|	КОЛИЧЕСТВО(1) КАК СтрокТоваров,
		|	1 КАК Порядок,
		|	ЗначенияПоУмолчанию.Договор КАК Договор,
		|	ЗначенияПоУмолчанию.ВидЦены КАК ВидЦены
		|ИЗ
		|	Потребления КАК Потребления
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
		|		ПО ВидыЗапасов.Ссылка = Потребления.ВидЗапасов
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК ЗначенияПоУмолчанию
		|	ПО
		|		Потребления.Отправитель = ЗначенияПоУмолчанию.ОрганизацияВладелец
		|		И ВидыЗапасов.ТипЗапасов = ЗначенияПоУмолчанию.ТипЗапасов
		|		И Потребления.Получатель = ЗначенияПоУмолчанию.ОрганизацияПродавец
		|	
		|СГРУППИРОВАТЬ ПО
		|	Потребления.ДатаОформления, 
		|	Потребления.Отправитель, 
		|	Потребления.Получатель,
		|	Потребления.Склад,
		|	Потребления.ТипЗапасов, 
		|	Потребления.НалогообложениеНДС,
		|	ЗначенияПоУмолчанию.Договор,
		|	ЗначенияПоУмолчанию.ВидЦены
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	(ВЫБОР ВидыЗапасов.ТипЗапасов
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями) КОНЕЦ) КАК ХозяйственнаяОперация,
		|	ДАТАВРЕМЯ(1,1,1) КАК ДатаОформления,
		|	ВидыЗапасов.Организация КАК Отправитель,
		|	НаДату.ОрганизацияВладелец КАК Получатель,
		|	Аналитика.Склад КАК Склад,
		|	ВидыЗапасов.ТипЗапасов КАК ТипЗапасов,
		|	ВидыЗапасов.НалогообложениеНДС КАК ПередачаПодДеятельность,
		|	ДАТАВРЕМЯ(1,1,1) КАК ДатаПоследнейПродажи,
		|	0 КАК СтрокТоваров,
		|	2 КАК Порядок,
		|	ЗначенияПоУмолчанию.Договор КАК Договор,
		|	ЗначенияПоУмолчанию.ВидЦены КАК ВидЦены
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки(&ГраницаПериода) КАК НаДату
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
		|		ПО ВидыЗапасов.Ссылка = НаДату.ВидЗапасовПродавца
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|	ПО
		|		НаДату.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки() КАК НаСейчас
		|		ПО НаДату.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
		|		И НаДату.НомерГТД = НаСейчас.НомерГТД
		|		И НаДату.ВидЗапасовПродавца = НаСейчас.ВидЗапасовПродавца
		|		И НаДату.ОрганизацияВладелец = НаСейчас.ОрганизацияВладелец
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК ЗначенияПоУмолчанию
		|	ПО
		|		НаДату.ОрганизацияВладелец = ЗначенияПоУмолчанию.ОрганизацияВладелец
		|		И ВидыЗапасов.ВидЗапасовВладельца.ТипЗапасов = ЗначенияПоУмолчанию.ТипЗапасов
		|		И ВидыЗапасов.Организация = ЗначенияПоУмолчанию.ОрганизацияПродавец
		|ГДЕ
		|	ЕСТЬNULL(НаСейчас.ВозвращеноОстаток, 0) > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок, ДатаОформления
		|");
		
	Отборы = РегистрыНакопления.ТоварыОрганизацийКПередаче.ОтборыТоваровКПередаче();
	Отборы.НачалоПериода = НачалоДня(Период.ДатаНачала);
	Отборы.КонецПериода = КонецДня(?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, '39991231'));
	
	Если Отборы.НачалоПериода > Отборы.КонецПериода Тогда
		ВызватьИсключение НСтр("ru = 'Дата начала периода должна быть меньше даты окончания периода'");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода", Отборы.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Отборы.КонецПериода);
	Запрос.УстановитьПараметр("ГраницаПериода", Новый Граница(Отборы.КонецПериода, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ТоварыКПередаче", РегистрыНакопления.ТоварыОрганизацийКПередаче.ТоварыКПередаче(Отборы));
	
	Результат = Запрос.Выполнить();
	КОформлению.Загрузить(Результат.Выгрузить());
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаДокументов;
		
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ВозвратТоваровМеждуОрганизациями.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПередачаТоваровМеждуОрганизациями.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область ПодсистемаЭлектронныедокументы

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если Элементы.Список.ПодчиненныеЭлементы.Найти("СостояниеВерсииЭД") <> Неопределено Тогда
		Элементы.Список.ПодчиненныеЭлементы.СостояниеВерсииЭД.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭДМеждуОрганизациями");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
