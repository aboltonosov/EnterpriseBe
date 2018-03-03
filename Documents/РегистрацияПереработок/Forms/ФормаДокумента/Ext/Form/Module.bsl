﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		// Создается новый документ.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		ЗаполнитьПериодСуммированногоУчетаПоПрошлымДокументам();
	КонецЕсли;
	
	ПриПолученииДанныхНаСервере();
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "СотрудникиСотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ДанныеФормыВОбъект();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьВторичныеДанныеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ПериодСуммированногоУчетаНачало

&НаКлиенте
Процедура ПериодСуммированногоУчетаНачалоПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодСуммированногоУчетаНачало", "МесяцНачалаСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаНачалоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодСуммированногоУчетаНачало", "МесяцНачалаСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаНачалоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодСуммированногоУчетаНачало", "МесяцНачалаСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаНачалоАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаНачалоОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ПериодСуммированногоУчетаОкончание

&НаКлиенте
Процедура ПериодСуммированногоУчетаОкончаниеПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодСуммированногоУчетаОкончание", "МесяцОкончанияСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаОкончаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодСуммированногоУчетаОкончание", "МесяцОкончанияСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаОкончаниеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодСуммированногоУчетаОкончание", "МесяцОкончанияСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаОкончаниеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодСуммированногоУчетаОкончаниеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДобавитьВыбранныхСотрудников(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиНормаЧасовПриИзменении(Элемент)
	ПосчитатьКоличествоСверхурочныхЧасовНаКлиенте(Элементы.Сотрудники.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОтработаноЧасовВПраздникиПриИзменении(Элемент)
	ПосчитатьКоличествоСверхурочныхЧасовНаКлиенте(Элементы.Сотрудники.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОтработаноЧасовПриИзменении(Элемент)
	ПосчитатьКоличествоСверхурочныхЧасовНаКлиенте(Элементы.Сотрудники.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.Сотрудник));
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		ОчиститьСтроку(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСверхурочно1_5ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСверхурочные(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСверхурочно2ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСверхурочные(ТекущиеДанные, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСверхурочно0ПриИзменении(Элемент)
	ПосчитатьКоличествоСверхурочныхЧасовНаКлиенте(Элементы.Сотрудники.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСпособКомпенсацииПереработкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Сверхурочно1_5 = 0;
	ТекущиеДанные.Сверхурочно2 = 0;
	РассчитатьВсего(ТекущиеДанные);
	
	Если ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата") Тогда
		ТекущиеДанные.Сверхурочно1_5 = ТекущиеДанные.Всего;
	Иначе
		ТекущиеДанные.Сверхурочно2 = ТекущиеДанные.Всего;
	КонецЕсли;
	РассчитатьСверхурочные(ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьСотрудниковНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация,
		Объект.Подразделение,
		Объект.Дата,
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
		
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСотрудника(Команда)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТекущиеДанные.Сотрудник));
	
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодСуммированногоУчетаНачало", "МесяцНачалаСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодСуммированногоУчетаОкончание", "МесяцОкончанияСтрокой");
	
	// заполним предупреждения 
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	ЗаполнитьВторичныеДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВторичныеДанныеФормы()
	ЗаполнитьСотрудниковФормы();
КонецПроцедуры

&НаСервере
Процедура ДанныеФормыВОбъект()

	Для каждого Сотрудник Из Объект.Сотрудники Цикл
		Если Сотрудник.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			Сотрудник.Сверхурочно1_5 = 0;
			Сотрудник.Сверхурочно2 = Сотрудник.Всего;
		КонецЕсли;
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудниковФормы()

	Для каждого Сотрудник Из Объект.Сотрудники Цикл
		Если Сотрудник.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			Сотрудник.Всего = Сотрудник.Сверхурочно2;
		Иначе
			Сотрудник.Всего = Сотрудник.Сверхурочно1_5 + Сотрудник.Сверхурочно2;
		КонецЕсли;
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ДобавитьВыбранныхСотрудников(ВыбранныеСотрудники)

	Для каждого ВыбранныйСотрудник Из ВыбранныеСотрудники Цикл
		НайденныеСотрудники = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ВыбранныйСотрудник));
		Если НайденныеСотрудники.Количество()=0 Тогда
			НовыйСотрудник = Объект.Сотрудники.Добавить();
			НовыйСотрудник.Сотрудник = ВыбранныйСотрудник;
			НовыйСотрудник.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
			
			РассчитатьСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныйСотрудник));
			
		КонецЕсли; 
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПериодСуммированногоУчетаПоПрошлымДокументам()
	ЗаполнитьЗначенияСвойств(Объект, УчетРабочегоВремениРасширенный.ПериодСуммированногоУчетаПоПрошлымДокументам(Объект.Организация, Объект.Дата));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСотрудниковНаСервере()
	
	// Получаем список сотрудников, работавших на суммированном учете в этот период.
	МассивСотрудников = ЗаполнитьСотрудников();
	РассчитатьСотрудников(МассивСотрудников, Истина);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСотрудников(МассивСотрудников, Очищать = Ложь)

	ТаблицаСотрудников = РасчетЗарплатыРасширенный.ПоказателиСуммированногоУчетаСотрудниковЗаПериод(
		МассивСотрудников,
		НачалоМесяца(Объект.ПериодСуммированногоУчетаНачало),
		КонецМесяца(Объект.ПериодСуммированногоУчетаОкончание));
		
	Если Очищать Тогда
		Объект.Сотрудники.Очистить();
		Для каждого Сотрудник Из ТаблицаСотрудников Цикл
			Если (Сотрудник.ОтработаноЧасов - Сотрудник.НормаЧасов) <= 0 Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = Объект.Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Сотрудник);
			НоваяСтрока.Сверхурочно0 = Сотрудник.ОтработаноЧасовВПраздники;
			НоваяСтрока.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
			ПосчитатьПоказателиСтроки(НоваяСтрока);
		КонецЦикла; 
	Иначе
		Для каждого Сотрудник Из МассивСотрудников Цикл
			РассчитанныйСотрудник = ТаблицаСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник))[0];
			СтрокаСотрудник = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
			Если СтрокаСотрудник.Количество() > 0 Тогда
				ТекущиеДанные = СтрокаСотрудник[0];
				ЗаполнитьЗначенияСвойств(ТекущиеДанные, РассчитанныйСотрудник);
				ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
				ТекущиеДанные.Сверхурочно0 = РассчитанныйСотрудник.ОтработаноЧасовВПраздники;
				ПосчитатьПоказателиСтроки(ТекущиеДанные);
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЗаполнитьСотрудников()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолученияРабочихМест = КадровыйУчет.ПараметрыДляЗапросВТРабочиеМестаСотрудниковПоСпискуСотрудников();
	ПараметрыПолученияРабочихМест.Организация  		= Объект.Организация;
	ПараметрыПолученияРабочихМест.Подразделение 	= Объект.Подразделение;
	ПараметрыПолученияРабочихМест.НачалоПериода		= НачалоМесяца(Объект.ПериодСуммированногоУчетаНачало);
	ПараметрыПолученияРабочихМест.ОкончаниеПериода  = КонецМесяца(Объект.ПериодСуммированногоУчетаОкончание);

	// Получаем рабочие места сотрудников
	КадровыйУчет.СоздатьВТРабочиеМестаСотрудников(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияРабочихМест);
	
	// Убираем неактуальных
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(ВТРабочиеМестаСотрудников.Период) КАК Период,
		|	ВТРабочиеМестаСотрудников.Сотрудник
		|ПОМЕСТИТЬ ВТПоследниеРабочиеМеста
		|ИЗ
		|	ВТРабочиеМестаСотрудников КАК ВТРабочиеМестаСотрудников
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТРабочиеМестаСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТРабочиеМестаСотрудников.Сотрудник
		|ПОМЕСТИТЬ ВТУволенные
		|ИЗ
		|	ВТРабочиеМестаСотрудников КАК ВТРабочиеМестаСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследниеРабочиеМеста КАК ВТПоследниеРабочиеМеста
		|		ПО ВТРабочиеМестаСотрудников.Сотрудник = ВТПоследниеРабочиеМеста.Сотрудник
		|			И ВТРабочиеМестаСотрудников.Период = ВТПоследниеРабочиеМеста.Период
		|ГДЕ
		|	ВТРабочиеМестаСотрудников.ВидСобытия = &ВидСобытияУволен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТРабочиеМестаСотрудников.Сотрудник,
		|	ВТРабочиеМестаСотрудников.Период КАК ДатаНачала,
		|	&ОкончаниеПериода КАК ДатаОкончания
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	ВТРабочиеМестаСотрудников КАК ВТРабочиеМестаСотрудников
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУволенные КАК ВТУволенные
		|		ПО ВТРабочиеМестаСотрудников.Сотрудник = ВТУволенные.Сотрудник
		|ГДЕ
		|	ВТУволенные.Сотрудник ЕСТЬ NULL ";
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(Объект.ПериодСуммированногоУчетаОкончание));
	Запрос.УстановитьПараметр("ВидСобытияУволен", ПредопределенноеЗначение("Перечисление.ВидыКадровыхСобытий.Увольнение"));
	Запрос.Выполнить();
	
	РасчетЗарплатыРасширенный.СоздатьВТПериодыРаботыСотрудниковНаСуммированномУчете(Запрос.МенеджерВременныхТаблиц);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВТКадровыеДанныеСотрудников.Сотрудник
		|ИЗ
		|	ВТПериодыРаботыСотрудниковНаСуммированномУчете КАК ВТКадровыеДанныеСотрудников
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТПоследниеРабочиеМеста
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТУволенные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиПериоды";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сотрудник");

КонецФункции

&НаКлиенте
Процедура ПосчитатьКоличествоСверхурочныхЧасовНаКлиенте(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПосчитатьПоказателиСтроки(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСтроку(ТекущиеДанные)

	ТекущиеДанные.НормаЧасов = 0;
	ТекущиеДанные.ОтработаноЧасов = 0;
	ТекущиеДанные.ОтработаноЧасовВПраздники = 0;
	ТекущиеДанные.Сверхурочно0 = 0;
	ТекущиеДанные.Сверхурочно1_5 = 0;
	ТекущиеДанные.Сверхурочно2 = 0;
	ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
	РассчитатьВсего(ТекущиеДанные);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПосчитатьПоказателиСтроки(ТекущиеДанные)

	РассчитатьВсего(ТекущиеДанные);
	
	Если ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата") Тогда
		ДополнитьСверхурочные(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДополнитьСверхурочные(ТекущиеДанные)
	
	СверхурочныеВсего = Макс(ТекущиеДанные.Всего, 0);
	ТекущиеСверхурочные = ТекущиеДанные.Сверхурочно1_5 + ТекущиеДанные.Сверхурочно2;
	Разница = СверхурочныеВсего - ТекущиеСверхурочные;
	
	Если Разница > 0 Тогда
		ТекущиеДанные.Сверхурочно1_5 = ТекущиеДанные.Сверхурочно1_5 + Разница;
	Иначе
		ТекущиеДанные.Сверхурочно2 = Макс(ТекущиеДанные.Сверхурочно2 + Разница, 0);
		РассчитатьСверхурочные(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСверхурочные(ТекущиеДанные, НачатьС1_5 = Истина)
	Сверхурочные = Макс(ТекущиеДанные.Всего, 0);
	Если НачатьС1_5 Тогда
		ТекущиеДанные.Сверхурочно1_5 = Мин(Сверхурочные, ТекущиеДанные.Сверхурочно1_5);
		ТекущиеДанные.Сверхурочно2 = Сверхурочные - ТекущиеДанные.Сверхурочно1_5;
	Иначе
		ТекущиеДанные.Сверхурочно2 = Мин(Сверхурочные, ТекущиеДанные.Сверхурочно2);
		ТекущиеДанные.Сверхурочно1_5 = Сверхурочные - ТекущиеДанные.Сверхурочно2;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьВсего(ТекущиеДанные)
	ТекущиеДанные.Всего = ТекущиеДанные.ОтработаноЧасов - ТекущиеДанные.НормаЧасов - ТекущиеДанные.Сверхурочно0;
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

&НаСервере
// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("Объект.Сотрудники");
	
	Возврат Массив;
	
КонецФункции

&НаСервере
// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",				Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",				Нстр("ru = 'подразделения'")));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#КонецОбласти