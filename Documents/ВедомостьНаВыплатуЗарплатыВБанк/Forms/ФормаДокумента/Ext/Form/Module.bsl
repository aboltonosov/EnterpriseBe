﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ОбновитьКомандыОбмена(ЭтотОбъект, Объект.ЗарплатныйПроект);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "ЗагруженоПодтверждениеЗачисленияЗарплаты" И Параметр = Объект.Ссылка Тогда
		ГруппаПодтверждениеИзБанкаДополнитьФорму();
	КонецЕсли;
	ОграничениеИспользованияДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ВзаиморасчетыССотрудникамиФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты)
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияДокументовЗачисленияЗарплаты"));
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи); 
	
	СохраняемыеЗначения = Новый Структура;
	СохраняемыеЗначения.Вставить("Бухгалтер", ТекущийОбъект.Бухгалтер);
	
	ЗарплатаКадры.СохранитьЗначенияЗаполненияОтветственныхРаботников(ТекущийОбъект.Организация, СохраняемыеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ОбновитьКомандыОбмена(ЭтотОбъект, Объект.ЗарплатныйПроект);
КонецПроцедуры

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	СпособВыплатыПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОснованийНажатие(Элемент, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьПредставлениеОснованийНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОкруглениеПриИзменении(Элемент)
	ОкруглениеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПроцентВыплатыПриИзменении(Элемент)
	ПроцентВыплатыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатныйПроектПриИзменении(Элемент)
	ЗарплатныйПроектПриИзмененииНаСервере();
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ОбновитьКомандыОбмена(ЭтотОбъект, Объект.ЗарплатныйПроект);
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура БухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиент.КомментарийНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ВнешниеХозяйственныеОперации

&НаКлиенте
Процедура ПеречислениеНДФЛВыполненоПриИзменении(Элемент)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьПеречислениеНДФЛВыполненоПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьСоставВыбор(ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ВзаиморасчетыССотрудникамиКлиент.ВедомостьПодобрать(ЭтаФорма);
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьСоставПередУдалением(ЭтаФорма, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеПриИзменении(Элемент)
	СоставКВыплатеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеОткрытие(Элемент, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьСоставКВыплатеОткрытие(ЭтаФорма, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СоставФизическоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеПодробныхДанныхПоСотрудникуВФормеДокументаВедомостьНаВыплатуЗарплатыВБанк");
	
КонецПроцедуры

&НаКлиенте
Процедура СоставНомерЛицевогоСчетаПриИзменении(Элемент)
	СоставПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Заполнить(Команда) Экспорт
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаполнениеДокументаВедомостьНаВыплатуЗарплатыВБанк");
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьЗаполнить(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьПодобрать(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗарплату(Команда)
	РедактироватьЗарплатуСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛ(Команда)
	РедактироватьНДФЛСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНДФЛ(Команда)
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьОбновитьНДФЛ(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьОплатаПоказать(ЭтаФорма, Элемент, НавигационнаяСсылка, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументПодтверждение(Команда)
	ОбменСБанкамиПоЗарплатнымПроектамКлиент.ОткрытьДокументПодтверждение(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗагрузитьДокументПодтверждение(Команда)
	ОткрытьФорму("Документ.ПодтверждениеЗачисленияЗарплаты.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВБанк(Команда)
	
	ОбменСБанкамиКлиент.СформироватьПодписатьОтправитьЭД(Объект.Ссылка);
	ОграничениеИспользованияДокументовКлиент.ПодключитьОбработчикОжиданияОкончанияКомандыЗакрытия(ЭтотОбъект, "Подключаемый_ПослеОтправкиВБанк");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтправленныйДокумент(Команда)
	
	ОбменСБанкамиКлиент.ОткрытьАктуальныйЭД(Объект.Ссылка, ЭтотОбъект);
	
КонецПроцедуры

#Область ОграничениеДокумента

&НаКлиенте
Процедура Подключаемый_ОграничитьДокумент(Команда)
	
	ОграничитьДокументНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область ВызовыСервера

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьОрганизацияПриИзмененииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура СпособВыплатыПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьСпособВыплатыПриИзмененииНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОкруглениеПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПараметрыРасчетаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПроцентВыплатыПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПараметрыРасчетаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиФормы.ВедомостьСоставОбработкаВыбораНаСервере(ЭтаФорма, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаСервере
Процедура СоставПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьСоставПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьСоставПослеУдаленияНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура СоставКВыплатеПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьСоставКВыплатеПриИзмененииНаСервере(ЭтаФорма)	
КонецПроцедуры

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ВзаиморасчетыССотрудникамиФормы.ВедомостьПодписантПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура ЗарплатныйПроектПриИзмененииНаСервере()
	УточнитьВидимостьВХО()
КонецПроцедуры

&НаСервере
Процедура УточнитьВидимостьВХО()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		Если ОбменСБанкамиПоЗарплатнымПроектам.ИспользоватьЭОИСБанком(Объект.ЗарплатныйПроект) Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Ведомость", Объект.Ссылка);
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ПодтверждениеЗачисленияЗарплаты.Ссылка КАК Ссылка
			|ИЗ
			|	Документ.ПодтверждениеЗачисленияЗарплаты КАК ПодтверждениеЗачисленияЗарплаты
			|ГДЕ
			|	ПодтверждениеЗачисленияЗарплаты.ПервичныйДокумент = &Ведомость
			|	И ПодтверждениеЗачисленияЗарплаты.Проведен";
			
			Элементы.ВыплатаЗарплатыГруппа.Видимость = Запрос.Выполнить().Пустой();
			
		Иначе
			Элементы.ВыплатаЗарплатыГруппа.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	ПроектВыбран = ЗначениеЗаполнено(Объект.ЗарплатныйПроект);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НомерРеестра", "Видимость", ПроектВыбран);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПослеОтправкиВБанк()
	
	Если ОграничениеИспользованияДокументовВызовСервера.ДокументОграничен(Объект.Ссылка) Тогда
		ОграничениеИспользованияДокументовКлиентСервер.УстановитьДоступностьДанныхФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОграничитьДокументНаСервере()
	
	ОграничениеИспользованияДокументовФормы.ОграничитьДокумент(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбратныеВызовы

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьЗаполнитьПервоначальныеЗначения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект) Экспорт
	
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПриПолученииДанныхНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ГруппаПодтверждениеИзБанкаДополнитьФорму();
	ОбменСБанкамиПоЗарплатнымПроектам.КомандыОбменаДополнитьФорму(ЭтотОбъект);
	
	УточнитьВидимостьВХО();
	
	ОграничениеИспользованияДокументовФормы.ПриПолученииДанныхНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ГруппаПодтверждениеИзБанкаДополнитьФорму()
	ОбменСБанкамиПоЗарплатнымПроектам.ГруппаПодтверждениеИзБанкаДополнитьФорму(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьПриПолученииДанныхСтрокиСостава(ЭтаФорма, СтрокаСостава)
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьОбработатьСообщенияПользователю(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьУстановитьДоступностьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей() Экспорт
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Бухгалтер");
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьУстановитьПредставлениеОплаты(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьЗаполнитьНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере() Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьОчиститьНаСервере(ЭтаФорма);
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников() Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормы.ВедомостьАдресСпискаПодобранныхСотрудников(ЭтаФорма)
КонецФункции

&НаКлиенте
Процедура РедактироватьЗарплатуСтроки(ДанныеСтроки) Экспорт
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьРедактироватьЗарплатуСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВзаиморасчетыССотрудникамиФормы.ВедомостьРедактироватьЗарплатуСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВзаиморасчетыССотрудникамиКлиентРасширенный.ВедомостьРедактироватьНДФЛСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьРедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормы.ВедомостьАдресВХранилищеЗарплатыПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьАдресВХранилищеНДФЛПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Процедура ОбновитьНДФЛНаСервере(ИдентификаторыСтрок) Экспорт
	ВзаиморасчетыССотрудникамиФормыРасширенный.ВедомостьОбновитьНДФЛНаСервере(ЭтаФорма, ИдентификаторыСтрок)
КонецПроцедуры

#КонецОбласти

#КонецОбласти
