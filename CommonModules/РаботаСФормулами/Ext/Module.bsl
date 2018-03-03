﻿
#Область ПрограммныйИнтерфейс

// Формирует дерево значений с колонками Наименование, Оператор, Сдвиг.
//
// Возвращаемое значение:
//  ДеревоЗначений - Пустое дерево операторов с колонками:
//  * Наименование - Строка - Наименование оператора.
//  * Оператор - Строка - Оператор.
//  * Сдвиг - Число - Сдвиг оператора.
//
Функция ПолучитьПустоеДеревоОператоров() Экспорт
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

// Добавляет в дерево операторов группу операторов с переданным наименованием.
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//  Наименование - Строка - наименование группы дерева операторов.
//
// Возвращаемое значение:
//  СтрокаДереваЗначений - Добавленная группа операторов.
//
Функция ДобавитьГруппуОператоров(Дерево, Наименование) Экспорт
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

// Добавляет в дерево операторов группу операторов с переданным наименованием.
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//  Родитель     - СтрокаДереваЗначений - Группа операторов, в которую необходимо добавить оператор
//  Наименование - Строка - наименование группы дерева операторов
//  Оператор     - Строка - Представление оператора на встроенном языке
//  Сдвиг        - Число - необходим для определения позиции курсора
//
// Возвращаемое значение:
//  СтрокаДереваЗначений - Добавленный оператор.
//
Функция ДобавитьОператор(Дерево, Родитель = Неопределено, Наименование, Оператор = Неопределено, Сдвиг = 0) Экспорт
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Формирует дерево со стандартными операторами "+", "-", "*", "/"
//
// Возвращаемое значение:
//  ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//
Функция ПолучитьСтандартноеДеревоОператоров() Экспорт
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, "Операторы");
	ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	Возврат Дерево;
	
КонецФункции

// Заполняет дерево операторов для конструктора формул.
//
// Параметры:
//  Параметры - Структрура - содержит виды операторов, которые необходимо добавить в дерево.
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы, в которой выполняется действия, 
//                                                      необходим для корректного помещения во временное хранилище.
//
// Возвращаемое значение:
//  Строка - Адрес во временном хранилище
//
Функция ПостроитьДеревоОператоров(Параметры, УникальныйИдентификатор) Экспорт
	
	Дерево = РаботаСФормулами.ПолучитьПустоеДеревоОператоров();
	
	Если Параметры.Свойство("СтандартныеОператоры") И Параметры.СтандартныеОператоры Тогда
		ДобавитьГруппуСтандартныхОператоров(Дерево);
	КонецЕсли;
	
	Если Параметры.Свойство("ЛогическиеОператоры") И Параметры.ЛогическиеОператоры Тогда
		ДобавитьГруппуЛогическихОператоров(Дерево);
	КонецЕсли;
	
	Если Параметры.Свойство("Функции") И Параметры.Функции Тогда
		ДобавитьГруппуФункции(Дерево);
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(Дерево, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет в дерево операторов группу стандартных операторов (+,-,*,/)
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//
Процедура ДобавитьГруппуСтандартныхОператоров(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Операторы'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");

КонецПроцедуры

// Добавляет в дерево операторов группу логических операторов
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//
Процедура ДобавитьГруппуЛогическихОператоров(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Логические операторы и константы'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='И'"),      " " + НСтр("ru='И'")      + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИЛИ'"),    " " + НСтр("ru='ИЛИ'")    + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='НЕ'"),     " " + НСтр("ru='НЕ'")     + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ИСТИНА'"), " " + НСтр("ru='ИСТИНА'") + " ");
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='ЛОЖЬ'"),   " " + НСтр("ru='ЛОЖЬ'")   + " ");

КонецПроцедуры

// Добавляет в дерево операторов группу функций
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево операторов. см. функцию ПолучитьПустоеДеревоОператоров().
//
Процедура ДобавитьГруппуФункции(Дерево)

	ГруппаОператоров = РаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("ru='Функции'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Максимум'"),    НСтр("ru='Макс(,)'"), 2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Минимум'"),     НСтр("ru='Мин(,)'"),  2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Округление'"),  НСтр("ru='Окр(,)'"),  2);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Целая часть'"), НСтр("ru='Цел()'"),   1);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Условие'"),     "?(,,)",              3);
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Предопределенное значение'"), НСтр("ru='ПредопределенноеЗначение()'"));
	РаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("ru='Значение заполнено'"), НСтр("ru='ЗначениеЗаполнено()'"));

КонецПроцедуры

#КонецОбласти
